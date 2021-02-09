default: sandpit-plan
.PHONY: sandpit-plan
subproject ?= unknown
all: '$(subproject)'

sandpit-plan:
	scripts/local-stack-action.sh delius-core-sandpit $(subproject) plan

sandpit-apply:
	scripts/local-stack-action.sh delius-core-sandpit $(subproject) apply

sandpit-unlock:
	scripts/local-unlock-stack.sh delius-core-sandpit


# SPG infrastructure Pipeline
eng-ci-plan: ## Run eng-ci-plan with ci_components_flag=true
	scripts/local-stack-action.sh delius-core-sandpit $(subproject) plan true

eng-ci-apply: ## Run eng-ci-apply with ci_components_flag=true
	scripts/local-stack-action.sh delius-core-sandpit $(subproject) apply true

eng-ci-destroy: ## Run eng-ci-destroy with ci_components_flag=true
	scripts/local-stack-action.sh delius-core-sandpit $(subproject) destroy true