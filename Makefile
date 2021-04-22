.DEFAULT_GOAL := help

help: ## List the targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

hclfmt: ## Format all .hcl files
	terragrunt hclfmt

tfsec: ## Run TFSec scan against the labs
	docker run --rm -it -v "$(CURDIR)/lab:/src" tfsec/tfsec-alpine:v0.39.22 /src

.PHONY: \
	hclfmt \
	tfsec \