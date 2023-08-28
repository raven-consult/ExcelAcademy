package main

import (
	"excel_academy/services/search"
	"fmt"
	"net"
	"net/http"

	"github.com/typesense/typesense-go/typesense"
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

	service := &IndexerService{
		Client: client,
	}

	fmt.Println("Listening on port " + port)
	if err := http.Serve(l, service); err != nil {
		panic(err)
	}
}
