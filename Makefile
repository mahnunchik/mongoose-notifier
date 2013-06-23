NODE_BIN ?= node_modules/.bin

COFFEE ?= $(NODE_BIN)/coffee
MOCHA ?= $(NODE_BIN)/mocha
COFFEELINT ?= $(NODE_BIN)/coffeelint

SRC_DIR := src
OUT_DIR := lib

SCRIPTS := $(patsubst $(SRC_DIR)/%.coffee, \
                     	$(OUT_DIR)/%.js, \
                     	$(wildcard $(SRC_DIR)/*.coffee))

.SUFFIXES:
.PHONY: all clean test lint

all: $(SCRIPTS)

debug:
	@echo $(SCRIPTS)

$(OUT_DIR)/%.js : $(SRC_DIR)/%.coffee
	@mkdir -p $(@D)
	$(COFFEE) -cb -o $(@D) $^

lint:
	$(COFFEELINT) -r -f coffeelint.json src/

test: lint $(SCRIPTS)
	$(MOCHA) --recursive --compilers coffee:coffee-script --reporter spec --colors

clean:
	rm -rf $(OUT_DIR)
