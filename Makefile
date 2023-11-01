# Makefile for building Docker image for metrics-scraper
BINARY := metrics-scraper
CGO_ENABLED := 0
DOCKERFILE := Dockerfile
registry_url := quay.io
image_name := $(registry_url)/platform9/dashboard-metrics-scraper
UPSTREAM_VERSION := $(shell git describe --tags HEAD | sed 's/-.*//')
image_tag := $(UPSTREAM_VERSION)-pmk-$(TEAMCITY_BUILD_ID)
PF9_TAG := $(image_name):$(image_tag)

.PHONY: build-image
pf9-image: Dockerfile
	@docker build -t $(PF9_TAG) -f $(DOCKERFILE) .
	echo $(PF9_TAG) > container-tag

.PHONY: push-image
pf9-push: build-image
	docker login
	docker push $(PF9_TAG)
	docker rmi $(PF9_TAG)