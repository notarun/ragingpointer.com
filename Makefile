NPM = npm
OUT = site
SRC = $(shell find src/*)

COMMIT_HASH = $(shell git rev-parse HEAD)
GIT_REPO = https://github.com/notarun/ragingpointer.com

all: node_modules $(OUT)

node_modules: package.json
	@echo "Installing dependencies"
	$(NPM) install

$(OUT): node_modules $(SRC)
	@echo "Generating output"
	mkdir -p $(OUT)
	node src/index.js

clean:
	@echo "Cleaning"
	rm -rf $(OUT) node_modules package-lock.json

# adapted from https://blog.bloomca.me/2017/12/15/how-to-push-folder-to-github-pages.html
deploy: clean $(OUT)
	@echo "Deploying: $(COMMIT_HASH)"
	cd $(OUT) \
	&& git init \
	&& git add -A \
	&& git commit -m "Deploy to gh-pages @ $(COMMIT_HASH)" \
	&& git remote add origin $(GIT_REPO) \
	&& git push --force origin master:gh-pages

.PHONY: all clean deploy
