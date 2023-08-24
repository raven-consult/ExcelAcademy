FROM golang:1.19-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go generate ./services/recommendations/...
RUN go build -o ./bin/recommendations ./services/recommendations/

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/bin/ /app/bin/

CMD ["/app/bin/recommendations"]
