
# Sample Python App with Docker, Helm, and ArgoCD

This repository contains a **sample Python Flask application** with automated Docker builds and Helm-based deployment support via ArgoCD.

---

## 📌 Features

The Python Flask application exposes two endpoints:

1. `/` – Returns the **application name** and **version**.
2. `/healthz` – Returns the **application status** `"ok"`.

The repository also includes:

* Dockerfile for containerizing the app
* Makefile for local builds and testing
* Helm chart for deployment
* GitHub Actions workflow for CI/CD automation

---

## 📁 Repository Structure

```
/
├── .github/workflows    # CI/CD workflow: builds Docker image (push disabled by default)
├── app                  # Python Flask application code
├── infra                # Helm chart files for deployment
├── namespace.yaml       # Namespace definition for ArgoCD deployment
├── requirements.txt     # Python dependencies
├── Dockerfile           # Docker image definition
└── Makefile             # Commands to build, run, and push Docker images
```

### Details

* **`.github/workflows`** – Builds the Docker image and optionally pushes to a registry (requires credentials).
* **`/app`** – Flask application code.
* **`/infra`** – Helm chart infrastructure for deployment.
* **`namespace.yaml`** – Kubernetes namespace for ArgoCD deployments.
* **`requirements.txt`** – Python app dependencies.
* **`Dockerfile`** – Container image definition.
* **`Makefile`** – Automates image building, tagging with git SHA, and optional pushing.

---

## ⚙️ Makefile Workflow

The Makefile allows **automated builds and pushes**, ensuring images are always tagged with the **current git commit SHA**.

### Variables

* `IMAGE_NAME` – Docker image name (default: `my-app`)
* `DOCKERFILE` – Path to Dockerfile (default: `Dockerfile`)
* `CONTEXT` – Build context (default: `.`)
* `GIT_SHA` – Short SHA of the current git commit

### Phony Targets

```makefile
.PHONY: build-sha push run
```

* Ensures commands always execute, even if files with the same name exist.

---

### 🔹 `build-sha`

Builds a Docker image tagged with the **short git SHA**:

```bash
make build-sha
```

**Example output:**

```
🏷️ Building Docker image: my-app:3f2a7b1
```

---

### 🔹 `push`

Pushes the SHA-tagged image to Docker Hub.

**Automatically triggers `build-sha` first**, ensuring the latest commit is always built before pushing:

```bash
make push
```

---

### 🔹 `run`

Run the Docker container locally:

```bash
make run
```

---

### Example Usage

```bash
# Build the Docker image with SHA tag
make build-sha

# Build and push the image automatically
make push

# Run the container locally
make run
```

---

## 🚀 Running Locally

1. Ensure Python dependencies are installed:

```bash
pip install -r requirements.txt
```

2. Build the Docker image:

```bash
make build-sha
```

3. Run the container:

```bash
make run
```

4. Access endpoints:

* [http://localhost:8080/](http://localhost:8080/) – App name and version
* [http://localhost:8080/healthz](http://localhost:8080/healthz) – Health check

---

## ⚙️ Deployment

* Helm chart files are in `/infra`
* Create a namespace via:

```bash
kubectl apply -f namespace.yaml
```

* Deploy with ArgoCD by pointing it to the Helm chart in `/infra`.
* GitHub Actions workflow can automate builds and pushes (requires credentials).

---

## 📦 Notes

* The SHA-based tagging ensures traceability of images.
* Makefile dependency ensures `push` always builds the latest SHA image first.
* Optional enhancements: tag images as `latest` in addition to SHA, push multiple tags, run container tests locally.

---

If you want, I can **also add a visual diagram** showing **Makefile workflow → Docker build → Push → ArgoCD deployment**, which makes the README very clear for new developers.

Do you want me to create that diagram?
