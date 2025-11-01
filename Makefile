# -----------------------------
# Makefile for building Docker images locally
# -----------------------------

# Variables
IMAGE_NAME ?= endeavour
IMAGE_TAG ?= v1.0.1
DOCKERFILE ?= Dockerfile
CONTEXT ?= .
USERNAME ?= mitalmgadoya

# Helper to get short git SHA
GIT_SHA := $(shell git rev-parse --short HEAD)

# Default target
.PHONY: setup build-local push-local build-sha push run clean

setup: 
	@echo "Setting up the environment..."
# Add any setup commands here if needed

build-local:
	@echo "Building Docker image: $(IMAGE_NAME):$(IMAGE_TAG)"
	docker build -f $(DOCKERFILE) -t $(IMAGE_NAME):$(IMAGE_TAG) $(CONTEXT)
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)

# Below will not work as there are no credentials provided for docker hub
push-local: build-local
	@echo "Pushing image to Docker Hub: $(USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)"
	docker push $(USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)


build-sha:
	@echo "Building Docker image with SHA tag: $(IMAGE_NAME):$(GIT_SHA)"
	docker build -f $(DOCKERFILE) -t $(IMAGE_NAME):$(GIT_SHA) $(CONTEXT)

run:
	@echo "Running Docker container: $(IMAGE_NAME):$(IMAGE_TAG)"
	docker run -it --rm -p 5000:5000 $(IMAGE_NAME):$(IMAGE_TAG)

# Below will not work as there are no credentials provided for docker hub
push: build-sha
	@echo "Pushing image to Docker Hub: $(IMAGE_NAME):$(GIT_SHA)"
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(USERNAME)/$(IMAGE_NAME):$(GIT_SHA)
	docker push $(USERNAME)/$(IMAGE_NAME):$(GIT_SHA)

clean:
	@echo "Removing local images"
	docker rmi -f $(IMAGE_NAME):$(IMAGE_TAG) || true
	docker image prune -f
