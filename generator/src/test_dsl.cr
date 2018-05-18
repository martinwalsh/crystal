# The `TestDSL` mixin provides a DSL of sorts, implemented using macros,
# for automatically defining the *test_description*, *test_workload* (in
# addition to attributes related to expect_raises). It intentionally
# resembles the RSpec DSL.
#
# NOTE: Use of the included macros are entirely optional. One may choose
#       to simply override the *test_description* and *test_workload* methods
#       a given `Exercise::TestCase` including-type instead.
module TestDSL
  macro included
    PROPERTIES = {} of Nil => Nil

    macro finished
      add_methods
    end
  end

  # For example:
  #
  # ```
  # _it "should #{description}" do
  #   "HelloWorld.hello.should eq(\"Hello, World!\")"
  # end
  # ```
  #
  # Results in the following methods at compile time:
  #
  # ```
  # def test_description
  #   "should #{description}"
  # end
  #
  # def test_workload
  #   "HelloWorld.hello.should eq(\"'Hello, World!\")"
  # end
  # ```
  macro _it(desc, &block)
    {% PROPERTIES[:description] = desc %}
    {% PROPERTIES[:workload] = block.body %}
  end

  # Example:
  #
  # ```
  # _expect_raises(ArgumentError, /.+/) do
  #   "HelloWorld.hello"
  # end
  # ```
  #
  # Resulting in
  macro _expect_raises(type = ArugumentError, with_message = nil, when = false, &block)
    {% PROPERTIES[:expect_raises_type] = type %}
    {% PROPERTIES[:expect_raises_trigger] = block.body || nil %}
    {% PROPERTIES[:expect_raises_regex] = with_message %}
    {% PROPERTIES[:expect_raises_when] = when.id %}
  end

  macro add_methods
    def test_description
      {{ PROPERTIES[:description] }}
    end

    def test_workload
      if !should_raise?
        {{ PROPERTIES[:workload] }}
      else
        {% _type = PROPERTIES[:expect_raises_type] %}
        {% _regex = PROPERTIES[:expect_raises_regex] %}
        {% _trigger = PROPERTIES[:expect_raises_trigger] %}
        "expect_raises(#{{{ _type }}}#{{{ _regex }} ? ", /#{{{ _regex }}}/" : ""}) do\n" +
        "    #{{{ _trigger }}}\n" +
        "  end"
      end
    end

    def _raise_is_expected?
      {{ PROPERTIES[:expect_raises_when] }}
    end
  end

  # Including types may choose to override the *should_raise?* method in
  # cases where the *when* argument to the *_expect_raises* macro is insufficient.
  # This controls the output of *test_workload*, determining if the typical "should eq"
  # stanza is used, or *expect_raises*.
  def should_raise?
    _raise_is_expected?
  end
end
