CLUSTER_NAME := hello-k8s
IMAGE_NAME := hello/hello-k8s
IMAGE_VERSION := 0.1.0

.PHONY: help
help: ## Show this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: docker-build
docker-build: ## Build the docker image
	docker build -t $(IMAGE_NAME):$(IMAGE_VERSION) .

.PHONY: cluster
cluster: ## Creates a k8s kind cluster
	kind create cluster --name $(CLUSTER_NAME)

.PHONY: ingress-nginx
ingress-nginx: ## Install nginx ingress controller into the cluster
	kubectl get ns ingress-nginx || kubectl create ns ingress-nginx
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update
	helm install -n ingress-nginx ingress-nginx ingress-nginx/ingress-nginx \
		--set controller.service.type=ClusterIP

.PHONY: delete-cluster
delete-cluster: ## Deletes the k8s kind cluster
	kind delete cluster --name $(CLUSTER_NAME)

.PHONY: copy-image
copy-image: docker-build ## Copies the image to the kind cluster
	kind load --name $(CLUSTER_NAME) docker-image $(IMAGE_NAME):$(IMAGE_VERSION)

.PHONY: deploy
deploy: copy-image ## Deploys the service to kubernetes
	kubectl apply -f deploy
