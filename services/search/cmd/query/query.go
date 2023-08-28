package main

import (
	"fmt"
	"net"

	"excel_academy/services/search"

	"github.com/typesense/typesense-go/typesense"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

var (
	port              = search.Getenv("PORT", "8080")
	typesensePort     = search.Getenv("TYPESENSE_PORT", "8108")
	apiKey            = search.Getenv("TYPESENSE_API_KEY", "xyz")
	typesensehostName = search.Getenv("TYPESENSE_HOSTNAME", "localhost")
)

var client *typesense.Client

func init() {
	host := fmt.Sprintf("http://%s:%s", typesensehostName, typesensePort)

	client = typesense.NewClient(
		typesense.WithServer(host),
		typesense.WithAPIKey(apiKey),
	)
}

func main() {
	l, err := net.Listen("tcp", ":"+port)
	if err != nil {
		panic(err)
	}

	var server *grpc.Server

	if search.IsDev() {
		server = grpc.NewServer()
		reflection.Register(server)
	} else {
		server = grpc.NewServer(
			grpc.ChainUnaryInterceptor(
				search.GetUnaryAuthorizer(search.FirebaseAuthorizer),
			),
		)
	}

	search.RegisterSearchServiceServer(server, &SearchService{
		Client: client,
	})

	fmt.Println("Server is running on port " + port)
	if err := server.Serve(l); err != nil {
		panic(err)
	}
}
