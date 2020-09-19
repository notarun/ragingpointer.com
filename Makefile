NPM = npm
OUT = site
SRC = $(shell find src/*)

all: node_modules $(OUT)

node_modules:
	@echo "Installing dependencies"
	$(NPM) install

$(OUT): node_modules $(SRC)
	@echo "Generating output"
	mkdir -p $(OUT)
	node src/index.js

clean:
	rm -rf $(OUT) node_modules

.PHONY: all clean
