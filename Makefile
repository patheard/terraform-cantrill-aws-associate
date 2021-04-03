.DEFAULT_GOAL := help

help: ## List the targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

hclfmt: ## Format all .hcl files
	terragrunt hclfmt

tfsec: ## Run TFSec scan against the directory given by "DIR=/some/directory"
	docker run --rm -it -v "$(DIR):/src" tfsec/tfsec-alpine /src

.PHONY: \
	hclfmt \
	tfsec \