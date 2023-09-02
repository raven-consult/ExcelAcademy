#!/usr/bin/env bash

mkdir -p lib/services/generated
protoc -I. \
  --dart_out=grpc:lib/services/generated/ \
  services/search/search.proto \
  services/recommendations/recommendations.proto
