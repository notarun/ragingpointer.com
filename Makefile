# Adapted from https://www.johnhawthorn.com/2018/01/this-website-is-a-makefile/

BUILD         = build
MARKDOWNFILES = $(shell find content/ -type f -name '*.md')
HTMLTARGETS	  = $(MARKDOWNFILES:content/%.md=$(BUILD)/%/index.html)
COMMIT_HASH   = $(shell git rev-parse HEAD)
GIT_USER      = $(shell git config user.name)
GIT_EMAIL     = $(shell git config user.email)
GIT_REPO      = $(shell git config remote.origin.url)

all: $(HTMLTARGETS) .meta/meta.json $(BUILD)/index.html $(BUILD)/feed.xml $(BUILD)/assets

$(BUILD)/%/index.html: content/%.md
	@mkdir -p $(dir $@)
	bin/render $< > $@

$(BUILD)/index.html: .meta/meta.json
	bin/mkindex $^ > $@

$(BUILD)/feed.xml: .meta/meta.json
	bin/mkfeed $^ > $@

$(BUILD)/assets: assets
	cp -r assets/ $@

$(BUILD)/CNAME:
	@echo "ragingpointer.com\nwww.ragingpointer.com" > $@

.meta/meta.json: $(MARKDOWNFILES)
	@mkdir -p $(dir $@)
	bin/mkmeta $^ > $@

clean:
	rm -rf $(BUILD) .meta

# Adapted from https://blog.bloomca.me/2017/12/15/how-to-push-folder-to-github-pages.html
gh-pages-deploy: all $(BUILD)/CNAME
	@echo "Deploying: $(COMMIT_HASH)"
	cd $(BUILD) \
	&& git init \
	&& git config user.name "$(GIT_USER)" \
	&& git config user.email "$(GIT_EMAIL)" \
	&& git add -A \
	&& git commit -m "Deploy to gh-pages @ $(COMMIT_HASH)" \
	&& git remote add origin $(GIT_REPO) \
	&& git push --force origin master:gh-pages

.PHONY: clean deploy
