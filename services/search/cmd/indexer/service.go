package main

import (
	"encoding/json"
	"excel_academy/services/search"
	"fmt"
	"net/http"

	"github.com/typesense/typesense-go/typesense"
)

type IndexerService struct {
	Client *typesense.Client
}

func (s *IndexerService) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	var req search.Course

	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		http.Error(w, "Error parsing JSON request", http.StatusBadRequest)
		return
	}

	res, err := addToCollection(s.Client, &req)
	if err != nil {
		fmt.Fprintf(w, "Error: %s\n", err)
		return
	}

	err = json.NewEncoder(w).Encode(res)
	if err != nil {
		fmt.Fprintf(w, "Error: %s\n", err)
		return
	}
}

func addToCollection(client *typesense.Client, course *search.Course) (*search.Course, error) {
	res, err := client.Collection("courses").Documents().Upsert(course)
	if err != nil {
		return nil, err
	}

	data := &search.Course{
		Title:        res["title"].(string),
		Price:        res["price"].(float64),
		Rating:       res["rating"].(float64),
		CourseId:     res["courseId"].(string),
		Description:  res["description"].(string),
		ThumbnailUrl: res["thumbnailUrl"].(string),
	}
	return data, nil
}
