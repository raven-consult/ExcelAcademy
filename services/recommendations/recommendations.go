package main

import (
	"fmt"
	"net"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

//go:generate protoc -I. --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative recommendations.proto

var (
	PORT        = getenv("PORT", "8080")
	DatabaseURL = getenv("RTDB_URL", "")
)

func main() {
	client, err := NewDatabaseClient(DatabaseURL)
	if err != nil {
		panic(err)
	}

	l, err := net.Listen("tcp", ":"+PORT)
	if err != nil {
		panic(err)
	}

	server := grpc.NewServer(
		grpc.ChainUnaryInterceptor(
			GetUnaryAuthorizer(firebaseAuthorizer),
		),
	)

	if isDev() {
		reflection.Register(server)
	}

	RegisterRecommendationsServiceServer(server, &RecommendationsServicer{
		Repository: &Repository{
			Database: client,
		},
	})

	fmt.Println("Starting server on port " + PORT + "...")
	if err := server.Serve(l); err != nil {
		panic(err)
	}
}
