IGNOREDIRS := "^(\.git|.crystal|docs|bin|img|script)$$"
EXERCISESDIR ?= exercises
EXERCISES = $(shell find exercises -maxdepth 1 -mindepth 1 -type d | cut -d'/' -f2 | sort | grep -Ev $(IGNOREDIRS))

FILEEXT = cr
SPECDIR = spec
EXERCISENAME := "$(subst -,_,$(EXERCISE))"
EXERCISEDIR  := $(EXERCISESDIR)/$(EXERCISE)
EXERCISESRCDIR := $(EXERCISEDIR)/src
EXERCISESPECDIR := $(EXERCISEDIR)/$(SPECDIR)
SPECFILE := $(EXERCISENAME)_spec.$(FILEEXT)
SUPERSPECFILE := $(SPECFILE).super
TMPSPECFILE := $(SPECFILE).tmp

GENERATORDIR ?= generator
GENERATORBIN := $(GENERATORDIR)/bin
GENERATORSDIR := $(GENERATORDIR)/src/generators
GENERATORS = $(shell find $(GENERATORSDIR) -name '*.cr' | xargs -I '{}' basename '{}' .cr | tr _ -)

G_SRCS := $(shell find $(GENERATORDIR) -name "*.cr" -or -name "*.tt" | grep -Ev '(/lib/|/spec/)')

EXERCISECLASS = $(shell echo $(EXERCISE) | awk '{split($$0,w,/[^a-z]+/);for(i=1;i<=length(w);i++){r=r toupper(substr(w[i],1,1)) substr(w[i],2);} print r}')

define GENERATOR_TEMPLATE
require "../generator"

class $(EXERCISECLASS)TestCase
  # If the `input` data type is relatively simple the following `Input` class
  # definition is unnecessary. Simply delete the class definiton and replace
  # the first argument to `Exercise::TestCase`.
  class Input
    JSON.mapping( <replace_with_the_correct_mapping> )
  end

  # Update the type of the `expected` value in canonical-data.json for this exercise.
  include Exercise::TestCase(Input, <replace_with_the_type_of_expected_data>)

  ## If you'd like to use the TestDSL, uncomment the following.
  ## Otherwise implement the `test_descripton` and `test_workload` methods.
  # include TestDSL

  # _it "should #{description}" do
  #   "#{test_class}.#{test_method}(#{input.<attribute>}).should eq(#{expected})"
  # end

  ## If this exercise's unit tests are expected to raise exceptions, and you have
  ## chosen to use the `TestDSL`, you may wish to uncomment the following and update
  ## as necessary. Otherwise, be sure to output the appropriate `expect_raises` stanza
  ## in the `test_workload` method when appropriate.

  # _expect_raises(ArgumentError, when: expected.nil?) do
  #   "#{test_class}.#{test_method}(#{input.<attribute>})"
  # end

  # Please delete all boilerplate comments in this file before submitting a PR.
  # Thank you for your contribution!
end

Generator.register :$(EXERCISECLASS)
endef

define EXERCISE_JSON
# Please add the following with any necessary modifications to config.json:
    {
      "uuid": "$(shell bin/configlet uuid 2>/dev/null)",
      "slug": "$(EXERCISE)",
      "core": false,
      "unlocked_by": null,
      "difficulty": 1,
      "topics": [

      ]
    }
endef

export GENERATOR_TEMPLATE
export EXERCISE_JSON

# TODO: The following steps should probably be added to the generator
exercise: bin/configlet
ifndef EXERCISE
	$(error The EXERCISE environment variable is required for this operation)
else
	@echo "=> creating boilerplate for $(EXERCISE)"
	mkdir -p $(EXERCISESRCDIR) $(EXERCISESPECDIR)
	@echo "-> creating source files for $(EXERCISE)"
	@[ ! -e $(EXERCISESRCDIR)/$(EXERCISE).cr ] || (echo 'ERROR: $(EXERCISESRCDIR)/$(EXERCISE).cr already exists!'; exit 1)
	@echo '# Please implement your solution to $(EXERCISE) in this file' > $(EXERCISESRCDIR)/$(EXERCISE).cr
	@[ ! -e $(EXERCISESRCDIR)/example.cr ] || (echo 'ERROR: $(EXERCISESRCDIR)/example.cr already exists!'; exit 1)
	@echo '# Please provide an example implementation for the solution to $(EXERCISE) in this file' >  $(EXERCISESRCDIR)/example.cr
	@echo "-> creating README.md for $(EXERCISE)"
	bin/configlet generate . --only=$(EXERCISE)
	@echo "-> creating generator boilerplate for $(EXERCISE)"
	@[ ! -e $(GENERATORSDIR)/$(EXERCISE).cr ] || (echo 'ERROR: $(EXERCISESRCDIR)/$(EXERCISE).cr already exists!'; exit 1)
	@echo "$$GENERATOR_TEMPLATE" > $(GENERATORSDIR)/$(subst -,_,$(EXERCISE)).cr
	@echo "$$EXERCISE_JSON"
	@echo "=> exercise generation complete for $(EXERCISE)"
	@echo "You may now edit $(GENERATORSDIR)/$(subst -,_,$(EXERCISE)).cr as necessary and run make generate-exercise GENERATOR=$(EXERCISE)."
endif

test-exercise:
	@echo "running formatting check for: $(EXERCISE)"
	@crystal tool format --check $(EXERCISESDIR)/$(EXERCISE)
	@echo "moving files around"
	@sed 's/pending/it/g' $(EXERCISESPECDIR)/$(SPECFILE) > $(EXERCISESPECDIR)/$(TMPSPECFILE)
	@mv $(EXERCISESPECDIR)/$(SPECFILE) $(EXERCISESPECDIR)/$(SUPERSPECFILE)
	@mv $(EXERCISESPECDIR)/$(TMPSPECFILE) $(EXERCISESPECDIR)/$(SPECFILE)
	@echo "running tests for: $(EXERCISE)"
	@cd $(EXERCISESDIR)/$(EXERCISE) && crystal spec
	@rm $(EXERCISESPECDIR)/$(SPECFILE)
	@mv $(EXERCISESPECDIR)/$(SUPERSPECFILE) $(EXERCISESPECDIR)/$(SPECFILE)
	@printf "\n"

test-exercises:
	@for exercise in $(EXERCISES); do EXERCISE=$$exercise $(MAKE) -s test-exercise || exit 1; done

$(GENERATORBIN):
	@mkdir -p $@

$(GENERATORBIN)/generator: $(G_SRCS) | $(GENERATORBIN)
	@crystal build $(GENERATORDIR)/generator.$(FILEEXT) -o generator/bin/generator

build-generator: $(GENERATORBIN)/generator

generate-exercise: $(GENERATORBIN)/generator
	@echo "generating spec file for generator: $(GENERATOR)"
	@generator/bin/generator $(GENERATOR)

generate-exercises:
	@for generator in $(GENERATORS); do GENERATOR=$$generator $(MAKE) -s generate-exercise || exit 1; done

test-generator:
	@echo "running generator tests"
	@cd $(GENERATORDIR) && crystal deps && crystal spec

test:
	@echo "running all the tests"
	@$(MAKE) -s test-exercises
	@$(MAKE) -s test-generator

bin/configlet: bin/fetch-configlet
	./bin/fetch-configlet

ci: bin/configlet
	./bin/configlet lint . --track-id=crystal
	$(MAKE) -s test

clean:
	rm -rf bin/configlet $(addprefix $(GENERATORDIR)/,.shards bin cache lib)

.PHONY: clean ci test test-generator build-generator test-exercise test-exercises generate-exercise generate-exercises exercise
