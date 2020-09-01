COMMIT=$(shell git rev-parse --short HEAD)
TAG_NAME=$(shell git describe --abbrev=0)

VERSION=
ifeq ($(TAG_NAME),$(shell git describe --abbrev=4))
	VERSION=$(TAG_NAME)
else
	VERSION=$(COMMIT)
endif


.PHONY: docker-build-all docker-push-all


docker-build-amd64:
	docker buildx build \
		--platform linux/amd64 \
		--build-arg BASEIMAGE_TAG=alpine-3.9.6 \
		--tag ameyuuno/unifi-led-light-switch:$(VERSION) \
		--tag ameyuuno/unifi-led-light-switch:$(VERSION)-amd64 \
		.


docker-build-arm64:
	docker buildx build \
		--platform linux/arm64 \
		--build-arg BASEIMAGE_TAG=alpine-3.9.6-arm64 \
		--tag ameyuuno/unifi-led-light-switch:$(VERSION)-arm64 \
		.


docker-build-all: docker-build-amd64 docker-build-arm64


docker-push-all:
	docker tag ameyuuno/unifi-led-light-switch:$(VERSION)-amd64 ameyuuno/unifi-led-light-switch:latest
	docker push ameyuuno/unifi-led-light-switch
