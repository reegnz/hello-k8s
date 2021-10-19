FROM golang:1.17-alpine AS builder

WORKDIR /build

COPY . .

RUN go build ./cmd/hello-k8s

## Final image
FROM alpine:3.12

COPY --from=builder /build/hello-k8s /hello-k8s

ENTRYPOINT ["/hello-k8s"]
