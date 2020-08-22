# Package Manager
PM = npm

all: dep clean site

dep:
	$(PM) install

site:
	$(PM) run build

clean:
	rm -rf site

.PHONY: all dep clean
