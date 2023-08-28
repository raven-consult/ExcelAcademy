package main

import (
	"excel_academy/services/search"
	"fmt"

	"github.com/typesense/typesense-go/typesense"
)

var (
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
	res, err := client.Collections().Create(search.CreateSchema())
	if err != nil {
		panic(err)
	}

	fmt.Println(res)
}
