FROM golang:1.19-alpine AS builder

ARG service

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN apk add protoc
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
RUN go generate ./services/search/...

RUN go build -o ./bin/service ./services/search/cmd/${service}

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/bin/ /app/bin/

CMD ["/app/bin/service"]
