package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

var (
	PORT        = getenv("PORT", "8080")
	DatabaseURL = getenv("RTDB_URL", "")
)

func main() {
	client, err := NewDatabaseClient(DatabaseURL)
	if err != nil {
		panic(err)
	}

	repo := &Repository{
		Database: client,
	}

	service := &RecommendationsService{
		Repository: repo,
	}

	fmt.Println("Starting server on port 8080")

	http.ListenAndServe(":"+PORT, service)
}

type RecommendationsService struct {
	Repository *Repository
}

func (r *RecommendationsService) ServeRecommendations(w http.ResponseWriter, req *http.Request) {
	res, err := r.Repository.GetCourses(req.Context())
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(res)
}

func (r *RecommendationsService) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	if req.Method == http.MethodGet && req.URL.Path == "/" {
		w.Write([]byte("OK"))
	} else if req.Method == http.MethodGet && req.URL.Path == "/recommend" {
		r.ServeRecommendations(w, req)
		return
	}
}
