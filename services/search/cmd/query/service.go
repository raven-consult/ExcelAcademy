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
	Client     *typesense.Client
	Repository *SearchRepository
	search.UnimplementedSearchServiceServer
}

func (s *SearchService) Query(ctx context.Context, in *search.QueryRequest) (*search.QueryResponse, error) {
	query := in.Query

	userId := ctx.Value(search.UserIdKey).(string)
	if userId == "" {
		return nil, status.Errorf(codes.Internal, "user id not found")
	}

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

	err = s.Repository.AddPreviousSearch(userId, query)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to store search: %v", err)
	}

	res := &search.QueryResponse{
		Results: queryResItems,
	}

	return res, nil
}

func (s *SearchService) GetPreviousSearches(ctx context.Context, in *search.GetPreviousSearchesRequest) (*search.GetPreviousSearchesResponse, error) {
	userID := in.UserId

	authUserId := ctx.Value(search.UserIdKey).(string)
	if authUserId == "" {
		return nil, status.Errorf(codes.Internal, "user id not found")
	}

	if userID != authUserId {
		return nil, status.Errorf(codes.PermissionDenied, "user id mismatch")
	}

	previousSearches, err := s.Repository.GetPreviousSearches(userID)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get previous searches: %v", err)
	}

	out := &search.GetPreviousSearchesResponse{}
	out.Queries = previousSearches

	return out, nil
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
