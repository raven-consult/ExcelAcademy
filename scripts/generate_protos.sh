#!/usr/bin/env bash

mkdir -p lib/services/generated
protoc \
  --dart_out=grpc:lib/services/generated/ \
  --go_out=. --go_opt=paths=source_relative \
  --go-grpc_out=. --go-grpc_opt=paths=source_relative \
  -I. services/recommendations/recommendations.proto

