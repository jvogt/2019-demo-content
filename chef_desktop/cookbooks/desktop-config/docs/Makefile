# we use pushd/popd here, and /bin/sh of our chefes/buildkite image is not bash
# so we have to override the default shell here
SHELL=bash

assets:
	git submodule update --init --recursive
	git submodule foreach git pull origin master
	git submodule foreach git reset --hard
	pushd chef-web-docs/themes/docs-new && make assets && popd

clean:
	pushd chef-web-docs/themes/docs-new && make clean && popd
	rm -rf chef-web-docs/resources/

clean_all:
	pushd chef-web-docs/themes/docs-new && make clean_all && popd
	rm -rf chef-web-docs/resources/
	rm -rf chef-web-docs/results/

preview_netlify: chef_web_docs_submodule
	pushd chef-web-docs && make assets; hugo --buildFuture --gc --minify --enableGitInfo && popd

serve_chef_web_docs: chef_web_docs_submodule
	pushd chef-web-docs && make assets; hugo server --buildDrafts --buildFuture --noHTTPCache && popd

chef_web_docs_submodule:
	git submodule update --init --recursive
	git submodule foreach git pull origin master
	git submodule foreach git reset --hard
	cp chef_web_docs_config.toml chef-web-docs/config.toml
	cp -R content/* chef-web-docs/content
	cp -R static/images/* chef-web-docs/static/images
	cp -R layouts/desktop chef-web-docs/layouts
	cp layouts/shortcodes/* chef-web-docs/layouts/shortcodes/
	cp layouts/partials/* chef-web-docs/layouts/partials
	mkdir -p chef-web-docs/data/desktop/resources
	cp data/desktop/resources/* chef-web-docs/data/desktop/resources

reset_chef_web_docs:
	git submodule foreach git reset --hard
	git submodule foreach git clean -f -d

serve: assets
	hugo server --buildDrafts --buildFuture --noHTTPCache

lint: assets
	hugo -D

# Generate blank resource pages, one for each yaml file in data/desktop/resources
# Each page includes the resource_yaml shortcode.
# Also generates an index page with the resource_yaml_all shortcode.
resource_files:
	rm content/desktop/resources/*
	dataDir=data/desktop/resources; \
	for f in $$(ls $${dataDir}); \
		do echo $${f}; \
		file=$${f%.yaml}; \
		hugo new -k resource content/desktop/resources/$${file}.md ; \
	done
	hugo new -k all_the_resources content/desktop/resources/_index.md ;
