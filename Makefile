COMMIT=$(shell git rev-parse HEAD)
TAG_COMMIT=$(shell git rev-list --tags --max-count=1)
TAG_NAME=$(shell git describe --tags $(TAG_COMMIT))

VERSION=
ifeq ($(COMMIT),$(TAG_COMMIT))
	VERSION=$(TAG_NAME)
else
	VERSION=$(shell git rev-parse --short HEAD)
endif

IMAGE=ghcr.io/ameyuuno/unifi-led-light-switch


.PHONY: docker-build-multiplatform


docker-build-multiplatform:
	docker buildx build --push --platform linux/amd64,linux/arm64 --tag $(IMAGE):$(VERSION) --tag $(IMAGE):latest .
