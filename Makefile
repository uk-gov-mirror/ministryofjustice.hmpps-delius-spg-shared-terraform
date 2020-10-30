default: sandpit-plan
.PHONY: sandpit-plan

sandpit-plan:
	scripts/local-stack-action.sh delius-core-sandpit $(subproject) plan

sandpit-apply:
	scripts/local-stack-action.sh delius-core-sandpit $(subproject) apply

sandpit-unlock:
	scripts/local-unlock-stack.sh delius-core-sandpit
