# Adapted from https://www.johnhawthorn.com/2018/01/this-website-is-a-makefile/

MARKDOWNFILES := $(shell find content/ -type f -name '*.md')
HTMLTARGETS	  := $(MARKDOWNFILES:content/%.md=build/%/index.html)

all: $(HTMLTARGETS) .meta/meta.json build/index.html build/feed.xml build/assets

build/%/index.html: content/%.md
	@mkdir -p $(dir $@)
	bin/render $< > $@

build/index.html: .meta/meta.json
	bin/mkindex $^ > $@

build/feed.xml: .meta/meta.json
	bin/mkfeed $^ > $@

build/assets: assets
	cp -r assets/ build/assets

.meta/meta.json: $(MARKDOWNFILES)
	@mkdir -p $(dir $@)
	bin/mkmeta $^ > $@

clean:
	rm -rf build .meta

.PHONY: clean
