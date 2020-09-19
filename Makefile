NPM = npm
SRC = $(shell find src/*)
OUT = site

all: node_modules $(OUT)

node_modules:
	@echo "Installing dependencies"
	$(NPM) install

$(OUT): node_modules index.js $(SRC)
	@echo "Generating output"
	mkdir -p $(OUT)
	node index.js

clean:
	rm -rf $(OUT) node_modules

.PHONY: all clean
