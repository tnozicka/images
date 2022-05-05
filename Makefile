all: build
.PHONY: all

MAKE_REQUIRED_MIN_VERSION:=4.2 # for SHELLSTATUS

ifneq "$(MAKE_REQUIRED_MIN_VERSION)" ""
$(call require_minimal_version,make,MAKE_REQUIRED_MIN_VERSION,$(MAKE_VERSION))
endif

# $1 - context dir
# $2 - tag (including repo URI)
# $3 - (optional) FROM replacement (to reference local image if needed)
define build-image
	podman build --format=docker --squash --from='$(3)' --tag='$(2)' '$(1)'
	echo '$(2)' >> '.build_state'

endef

# $1 - tag (including repo URI)
define publish-image
	podman push '$(1)'

endef

build:
	> '.build_state'
	$(call build-image,./debug,quay.io/tnozicka/debug,)
.PHONY: build

publish-last-build:
	$(foreach i,$(shell cat '.build_state')$(if $(filter $(.SHELLSTATUS),0),,$(error can not read .build_state)),$(call publish-image,$(i)))
.PHONY: publish-last-build

clean:
	$(RM) '.build_state'
.PHONY: clean
