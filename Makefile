REVISION ?= $(shell git rev-parse --short=7 HEAD)

all: build

build: build/main.dart.js slo-libsonnet-web

slo-libsonnet-web:
	CGO_ENABLED=0 go build -v -ldflags '-w -extldflags '-static''

kubernetes.yaml: kubernetes.jsonnet
	jsonnet -J vendor --ext-str tag=$(REVISION) kubernetes.jsonnet | gojsontoyaml > kubernetes.yaml

build/main.dart.js: web/main.dart lib/app_component.dart lib/app_component.html
	webdev build
