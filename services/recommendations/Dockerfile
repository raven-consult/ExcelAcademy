FROM golang:1.19-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN apt update -y \
  && apt install -y curl unzip \
  && rm -rf /var/lib/apt/lists/*

ENV PB_REL="https://github.com/protocolbuffers/protobuf/releases"
RUN curl -LO $PB_REL/download/v3.15.8/protoc-3.15.8-linux-x86_64.zip \
  && unzip protoc-3.15.8-linux-x86_64.zip -d /usr/bin

RUN go generate ./services/recommendations/...
RUN go build -o ./bin/recommendations ./services/recommendations/

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/bin/ /app/bin/

CMD ["/app/bin/recommendations"]
