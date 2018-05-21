require "json"

require "./renderable"
require "./test_dsl"

module Exercise
  # A `Spec` represents the root node of an exercise's canonical-data.
  #
  # It provides a fixed `JSON.mapping` consistent with the canonical-data.json schema.
  struct Spec(T)
    include Renderable

    JSON.mapping({
      exercise: String,
      version:  String,
      comments: { type: Array(String), nilable: true },
      cases:    Array(T | TestGroup(T)),
    })

    # The most common entrypoint for exercise generation, the *from_canonical*
    # class method takes a string representation of the canonical-data json,
    # passes it to *from_json* and uses the resulting object to push additional
    # settings down into subordinates types (i.e. `TestGroup` and `TestCase`) for
    # use in ECR template and supporting methods (see `Spec.inject` for more info).
    def self.from_canonical(data)
       inject from_json(data)
    end

    # Injects references and data into subordinate `TestCase` and `TestGroup` instances.
    # This method must be invoked to link `Spec` instances with subordinate `TestGroup`
    # and `TesCase` objects, and the easiest way to do that is to create an instance using
    # `Spec.from_canonical`.
    private def self.inject(instance)
      # Set a reference to this Exercise instance for all
      # subordinate `TestGroup` and `TestCase` instances, as applicable.
      instance.cases.map do |c|
        c.parent = instance
      end

      # Enable the first test case. This will pass through
      # a `TestGroup`, if present, to the first `TestCase` instance.
      instance.cases.first.test_prefix = "it"

      # Removes whitespace between the last
      # item of each group and the surrounding block.
      instance.cases.last.delimiter = ""
      instance.cases.each do |c|
        c.cases.last.delimiter = "" if c.responds_to? :cases
      end

      instance
    end

    # Returns a CamelCase version of the exercise name for use in a `TestCase`.
    def class_name
      exercise.split('-').map(&.capitalize).join
    end

    delegate include_spec_helper, to: @cases.first
    delegate describe_contextual, to: @cases.first
    delegate test_class, to: @cases.first

    private def has_describe_contextual?
      !describe_contextual.empty?
    end

    template_filename "exercise.tt"
  end

  # A `TestGroup` is a collection of `TestCase` groups.
  class TestGroup(T)
    include Renderable

    getter parent : Spec(T)? = nil
    property group : TestGroup(T)? = nil
    property visible : Bool = true

    JSON.mapping({
      description: String,
      comments:    { type: Array(String), nilable: true },
      cases:       Array(T | TestGroup(T)),
    })

    # Allows passing a value to the *test_prefix* attribute of the first `TestCase`
    # known to this `TestGroup` instance; it is used to enable only the first test
    # case (with "it"), while continuing to disable ("pending") all others during
    # spec rendering.
   def test_prefix=(prefix)
      cases.first.test_prefix = prefix
    end

   def parent=(instance)
      @parent = instance
      cases.each do |c|
        c.parent = instance
        c.group = self
      end
    end

    delegate test_method, to: @cases.first
    delegate include_spec_helper, to: @cases.first
    delegate describe_contextual, to: @cases.first
    delegate describe_group, to: @cases.first
    delegate test_class, to: @cases.first

    private def has_describe_group?
      !describe_group.empty?
    end

    template_filename "test_group.tt"
  end

  # The `TestCase` mixin represents an individual unit test to be rendered to the resulting
  # spec file. It should be included by a user-implemented class that provides additional
  # instructions for rendering.
  module TestCase(In, Out)
    include Renderable

    macro included
      property parent : Exercise::Spec({{ @type }})? = nil
      property group : Exercise::TestGroup({{ @type }})? = nil
    end

    property test_prefix : String = "pending"
    getter include_spec_helper : Bool = false
    getter describe_contextual : String = ""
    getter describe_group : String = ""

    # Use of this macro in a `TestCase` including type alters the top-level exercise
    # template, adding `require "./spec_helper"`, so that helper methods/macros (like
    # *bonus* are available for use in the generated spec file.
    macro spec_helper
      getter include_spec_helper : Bool = true
    end

    # Use of this macro with alter the *test_prefix* for unit tests matching
    # the regex provided in the *on* argument.
    macro bonus_prefix(on = nil)
      {% if on %}
      def test_prefix
        description.match({{ on.id }}) ? "bonus" : @test_prefix
      end
      {% end %}
    end

    # Overrides the default *describe_contextual* (defaults to an empty string), and
    # results in all unit tests, and test groups, being wrapped in a secondary
    # `describe` block.
    macro describe_contextual(method_name)
      def describe_contextual
        {{ method_name }}
      end
    end

    # Overrides the default *describe_group* (defaults to an empty string), and
    # results in test groups, of type `TestGroup`, being wrapped in a secondary
    # `describe` block.
    macro describe_group(group_message)
      def describe_group
        describe_group do
          {{ group_message }}
        end
      end
    end

    protected def describe_group
      if @group
        # Without `not_nil!`, the yielded block will be evaluated
        # in the context of this instance and not the group's.
        with @group.not_nil! yield
      else
        raise "Unable to lookup describe_group. No `TestGroup` available for #{self.inspect}."
      end
    end

    JSON.mapping({
      description: String,
      comments:    { type: Array(String), nilable: true },
      property:    String,
      input:       In,
      expected:    Out,
    })

    # Returns the *class_name* value for the related `Spec` object; represents the
    # name of the class under test (e.g. hello-world -> HelloWorld).
    def test_class
      "#{parent.try &.class_name}"
    end

    # overrides the default *test_class* method, which by default returns
    # the `Spec` object's *class_name* value.
    macro test_class(value)
      def test_class
        {{ value }}
      end
    end

    # A wrapper around the *property* attribute found in this exercise's canonical-data.json,
    # properly downcased and underscored. Can be overridden in subclasses, if desired.
    private def test_method
      property.gsub(/([a-z])([A-Z])/, "\\1_\\2").downcase
    end

    abstract def test_workload
    abstract def test_description

    template_filename "test_case.tt"
  end
end
