FROM golang:1.19-bullseye AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN apt update -y \
  && apt install -y unzip \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

ENV PB_REL="https://github.com/protocolbuffers/protobuf/releases"
RUN curl -LO $PB_REL/download/v3.15.8/protoc-3.15.8-linux-x86_64.zip \
  && unzip protoc-3.15.8-linux-x86_64.zip -d protoc3 \
  && mv protoc3/bin/* /usr/local/bin/ \
  && mv protoc3/include/* /usr/local/include/ \
  && rm -rf protoc-3.15.8-linux-x86_64.zip protoc3

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

RUN go generate ./services/recommendations/...
RUN go build -o ./bin/recommendations ./services/recommendations/

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/bin/ /app/bin/

CMD ["/app/bin/recommendations"]
