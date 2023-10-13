package main

import (
	"context"
	"net/http"
	"os"
	"strings"

	log "github.com/sirupsen/logrus"

	firebase "firebase.google.com/go/v4"
)

func Getenv(key, fallback string) string {
	value := os.Getenv(key)
	if len(value) == 0 {
		return fallback
	}
	return value
}

func isDev() bool {
	return len(os.Getenv("DEBUG")) != 0
}

type User struct {
	UID   string `json:"uid"`
	Email string `json:"email"`
}

func WithAuthentication(h http.Handler) http.Handler {
	authFn := func(rw http.ResponseWriter, req *http.Request) {
		defer func() {
			if r := recover(); r != nil {
				log.Error("Recovered in ", r)
			}
		}()

		app, err := firebase.NewApp(req.Context(), nil)
		if err != nil {
			http.Error(rw, "Could not be authorized", http.StatusInternalServerError)
		}

		auth, err := app.Auth(req.Context())
		if err != nil {
			http.Error(rw, "Could not be authorized", http.StatusInternalServerError)
		}

		values := req.Header["authorization"]

		if len(values) == 0 {
			http.Error(rw, "Authorization not provided", http.StatusUnauthorized)
		}

		idToken := values[0]
		token, err := auth.VerifyIDToken(req.Context(), strings.Split(idToken, " ")[1])
		if err != nil {
			http.Error(rw, "Could not be authorized", http.StatusInternalServerError)
		}

		user, err := auth.GetUser(req.Context(), token.UID)
		if err != nil {
			http.Error(rw, "Could not be authorized", http.StatusInternalServerError)
		}

		newReq := req.WithContext(context.WithValue(req.Context(), "user", user))
		h.ServeHTTP(rw, newReq)
	}
	return http.HandlerFunc(authFn)
}
