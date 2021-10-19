# hello-k8s

An example application written in go, deployed to k8s.

## Prerequisites

Make sure you have the following tools available on your developer machine:
- make
- docker
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [kind](https://kubernetes.io/docs/tasks/tools/#kind)
- [helm](https://helm.sh/docs/intro/install/)

## Running

To spin up the cluster, run

```sh
make cluster
make ingress-nginx
```

To build and deploy the service into the cluster, run

```sh
make deploy
```

## Testing the result

port-forward the ingress controller to your local host
(this would be unnecessary if you'd use svc type NodePort
or LoadBalancer in a real deployment scenario).

```sh
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80
```

Invoke the service and observe that the pods are load-balanced.

```sh
while true; do curl -H 'Host: hello-k8s.example.com' localhost:8080; sleep 1; done
```
