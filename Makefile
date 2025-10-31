# -----------------------------
# Makefile for building Docker images locally
# -----------------------------

# Variables
IMAGE_NAME ?= endeavour
IMAGE_TAG ?= latest
DOCKERFILE ?= Dockerfile
CONTEXT ?= .
USERNAME ?= MitalGadoya

# Helper to get short git SHA
GIT_SHA := $(shell git rev-parse --short HEAD)

# Default target
.PHONY: all build build-sha run push clean
all: build


build:
	@echo "Building Docker image: $(IMAGE_NAME):$(IMAGE_TAG)"
	docker build -f $(DOCKERFILE) -t $(IMAGE_NAME):$(IMAGE_TAG) $(CONTEXT)

build-sha:
	@echo "Building Docker image with SHA tag: $(IMAGE_NAME):$(GIT_SHA)"
	docker build -f $(DOCKERFILE) -t $(IMAGE_NAME):$(GIT_SHA) $(CONTEXT)

run:
	@echo "Running Docker container: $(IMAGE_NAME):$(IMAGE_TAG)"
	docker run -it --rm -p 5000:5000 $(IMAGE_NAME):$(IMAGE_TAG)

# Below will not work as there are no credentials provided for docker hub
push: build-sha
	@echo "Pushing image to Docker Hub: $(IMAGE_NAME):$(GIT_SHA)"
	docker push $(IMAGE_NAME):$(GIT_SHA)

clean:
	@echo "Removing local images"
	docker rmi -f $(IMAGE_NAME):$(IMAGE_TAG) || true
	docker image prune -f
