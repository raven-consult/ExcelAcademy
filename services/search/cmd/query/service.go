package main

import (
	"context"
	"excel_academy/services/search"

	"github.com/typesense/typesense-go/typesense"
	"github.com/typesense/typesense-go/typesense/api"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type SearchService struct {
	Client *typesense.Client
	search.UnimplementedSearchServiceServer
}

func (s *SearchService) Query(ctx context.Context, in *search.QueryRequest) (*search.QueryResponse, error) {
	query := in.Query

	queryRes, err := querySearchServer(client, query)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to query: %v", err)
	}

	queryResItems := []*search.QueryResult{}
	for _, course := range queryRes {
		queryResItems = append(queryResItems, &search.QueryResult{
			CourseId: course.CourseId,
		})
	}

	res := &search.QueryResponse{
		Results: queryResItems,
	}

	return res, nil
}

func querySearchServer(client *typesense.Client, query string) ([]*search.Course, error) {
	params := &api.SearchCollectionParams{
		Q:       query,
		QueryBy: "title, description",
	}

	searchResult, err := client.Collection("courses").Documents().Search(params)
	if err != nil {
		return nil, err
	}

	courses := []*search.Course{}
	for _, hit := range *searchResult.Hits {
		courses = append(courses, &search.Course{
			Title:        (*hit.Document)["title"].(string),
			Price:        (*hit.Document)["price"].(float64),
			Rating:       (*hit.Document)["rating"].(float64),
			CourseId:     (*hit.Document)["courseId"].(string),
			Description:  (*hit.Document)["description"].(string),
			ThumbnailUrl: (*hit.Document)["thumbnailUrl"].(string),
		})
	}
	return courses, nil
}
