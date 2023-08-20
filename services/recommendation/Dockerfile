FROM golang:1.19-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o ./bin/recommendation ./services/recommendation/

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/bin/ /app/bin/

CMD ["/app/bin/recommendation"]
