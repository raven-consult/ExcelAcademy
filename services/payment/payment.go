package main

import (
	"net"
	"net/http"
	"os"

	logging "excel_academy/common/logging"
	"excel_academy/services/payment/discounts"

	log "github.com/sirupsen/logrus"
)

var (
	port                     = Getenv("PORT", "8080")
	PAYSTACK_SECRET          = os.Getenv("PAYSTACK_SECRET")
	GOOGLE_PROJECT_ID string = os.Getenv("GOOGLE_PROJECT_ID")
)

func init() {
	log.SetOutput(os.Stdout)
	log.SetLevel(log.InfoLevel)
	log.SetFormatter(&log.JSONFormatter{})
}

func main() {
	l, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatal(err)
	}

	service := &PaymentService{
		SecretKey:    PAYSTACK_SECRET,
		DiscountRepo: discounts.NewDiscountRepository(),
	}

	handler := logging.WithLogging(service)
	if !isDev() {
		handler = WithAuthentication(handler)
	}

	log.Info("Listening on port " + port)
	if err := http.Serve(l, handler); err != nil {
		panic(err)
	}
}
