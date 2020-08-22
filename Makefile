# Package Manager
PM = npm

all: node_modules site

node_modules:
	$(PM) install

site: node_modules
	$(PM) run build

.PHONY: all
