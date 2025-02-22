.DEFAULT_GOAL := help

.PHONY: help
help:  ## Show this help.
	@grep -E '^\S+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: build
build: ## Build the docker image
	docker compose build

.PHONY: up
up: ## Run the docker container
	docker compose up -d

.PHONY: down
down: ## Stop the docker container
	docker compose down

.PHONY: add
add: ## Add package to the project ex: make add package=XX
	docker compose run --rm --no-deps app uv add $(package)
	make build

.PHONY: add-dev
add-dev: ## Add dev package to the project ex: make add-dev package=XX
	docker compose run --rm --no-deps app uv add --dev $(package)
	make build

.PHONY: test-unit
test-unit: ## Run unit tests
	docker compose run --rm app uv run pytest test/unit -ra

.PHONY: test-integration
test-integration: ## Run integration tests
	docker compose run --rm app uv run pytest test/integration -ra

.PHONY: test-acceptance
test-acceptance: ## Run acceptance tests
	docker compose run --rm app uv run pytest test/acceptance -ra

.PHONY: test
test: test-unit
#  test-integration test-acceptance ## Run tests

