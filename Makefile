.DEFAULT_GOAL := build

dep:
	curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
	dep ensure -vendor-only

# The build targets allow to build the binary and docker image
.PHONY: build build.docker

BINARY        ?= oauth2_proxy
SOURCES        = $(shell find . -name '*.go')
IMAGE         ?= quay.io/fakod/$(BINARY)
VERSION       ?= $(shell git describe --tags --always --dirty)
BUILD_FLAGS   ?= -v
LDFLAGS       ?= -w -s

build: build/$(BINARY)

build/$(BINARY): $(SOURCES)
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o build/$(BINARY) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" .

build.push: build.docker
	docker push "$(IMAGE):$(VERSION)"

build.docker:
	docker build --rm --tag "$(IMAGE):$(VERSION)" .

clean:
	@rm -rf build
