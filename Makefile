COMMIT=$(shell git rev-parse HEAD)
TAG_COMMIT=$(shell git rev-list --tags --max-count=1)
TAG_NAME=$(shell git describe --tags $(TAG_COMMIT))

VERSION=
ifeq ($(COMMIT),$(TAG_COMMIT))
	VERSION=$(TAG_NAME)
else
	VERSION=$(shell git rev-parse --short HEAD)
endif

IMAGE=ameyuuno/unifi-led-light-switch


.PHONY: docker-build


docker-build:
	docker buildx build --load --platform linux/arm64 --tag $(IMAGE):$(VERSION) --tag $(IMAGE):latest .
	docker buildx build --load --platform linux/amd64 --tag $(IMAGE):$(VERSION) --tag $(IMAGE):latest .

docker-push:
	docker push $(IMAGE)
