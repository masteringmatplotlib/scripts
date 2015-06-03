ROOT_DIR = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BUNDLE_NAME = code-bundle
BUNDLE_DIR = $(shell dirname $(ROOT_DIR))/$(BUNDLE_NAME)
BUNDLE_ZIP = $(BUNDLE_DIR).zip
CHAPTERS = 01-preview 02-architecture 03-apis 04-interaction 05-high-level 06-custom-and-config 07-cloud-deploy 08-big-data 09-clustering
REPO_BASE = git@github.com:masteringmatplotlib

# git clone git@github.com:masteringmatplotlib/preview.git 01-preview
# git submodule init && git submodule update

$(BUNDLE_DIR):
	@echo
	@echo "Creating $(BUNDLE_DIR) ..."
	@mkdir $(BUNDLE_DIR)
	@make download-code
	@make strip-git

$(BUNDLE_ZIP):
	@echo
	@echo "Creating $(BUNDLE_ZIP) ..."
	@zip -r $(BUNDLE_DIR) $(BUNDLE_DIR)

bundle: $(BUNDLE_DIR) $(BUNDLE_ZIP)
	@echo
	@echo "Your code bundle is available here:"
	@echo "  $(BUNDLE_ZIP)"

download-code:
	@echo
	@echo "Downloading code ..."
	@for CHAP in $(CHAPTERS); \
	do \
	REPO=`echo $$CHAP|cut -c 4-`; \
	git clone $(REPO_BASE)/$${REPO}.git $(BUNDLE_DIR)/$$CHAP; \
	cd $(BUNDLE_DIR)/$$CHAP && \
	git submodule init && git submodule update; \
	done

strip-git:
	@echo
	@echo "Removing git files ..."
	@rm -rf $(BUNDLE_DIR)/*/.git*
	@rm -rf $(BUNDLE_DIR)/*/include/.git

bundle-clean:
	@echo
	@echo "Removing $(BUNDLE_DIR) ..."
	@rm -rf $(BUNDLE_DIR)

bundle-zip-clean:
	@echo
	@echo "Removing $(BUNDLE_ZIP) ..."
	@rm -f $(BUNDLE_ZIP)

clean-all: bundle-clean bundle-zip-clean
