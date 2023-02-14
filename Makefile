SHELL := /bin/bash
.PHONY: help

help: ## Display this help page
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[33m%-30s\033[0m %s\n", $$1, $$2}'

lint: ## Lint files with shellcheck
	@find src/*.sh -type f -exec "shellcheck" "-x" {} \;

generate-docs: ## Build documentation using docker container
	docker build . -t bash-tui-toolkit/shdoc -f .development/docs/Dockerfile
	docker run --rm  bash-tui-toolkit/shdoc 'shdoc < logging.sh ' 2>&1 > docs/modules/Logging.md
	docker run --rm  bash-tui-toolkit/shdoc 'shdoc < prompts.sh ' 2>&1 > docs/modules/Prompts.md
	docker run --rm  bash-tui-toolkit/shdoc 'shdoc < user_feedback.sh ' 2>&1 > docs/modules/User-Feedback.md
