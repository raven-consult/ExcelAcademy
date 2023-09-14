package main

import (
	"context"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/db"
)

type SearchRepository struct {
	Client *db.Client
}

type SearchUser struct {
	UserID   string   `json:"user_id"`
	Searches []string `json:"searches"`
}

func NewDatabaseClient(DatabaseURL string) (*db.Client, error) {
	config := &firebase.Config{
		DatabaseURL: DatabaseURL,
	}

	app, err := firebase.NewApp(context.Background(), config)
	if err != nil {
		return nil, err
	}

	client, err := app.Database(context.Background())
	if err != nil {
		return nil, err
	}

	return client, nil
}

func (s *SearchRepository) AddPreviousSearch(userID string, query string) error {
	var searchUser SearchUser
	err := s.Client.NewRef("searches/"+userID).Get(context.Background(), &searchUser)
	if err != nil {
		return err
	}

	searchUser.Searches = append(searchUser.Searches, query)

	err = s.Client.NewRef("searches/"+userID).Set(context.Background(), searchUser)
	if err != nil {
		return err
	}

	return nil
}

func (r *SearchRepository) GetPreviousSearches(userID string) ([]string, error) {
	var searchUser SearchUser
	// TODO: Make use of pagination and remove older searches
	err := r.Client.NewRef("searches/"+userID).Get(context.Background(), &searchUser)
	if err != nil {
		return nil, err
	}

	return searchUser.Searches, nil
}
