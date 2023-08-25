package main

import (
	"context"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type RecommendationsServicer struct {
	Repository *Repository
	UnimplementedRecommendationsServiceServer
}

func (s *RecommendationsServicer) GetLatestCourses(ctx context.Context, in *GetLatestCoursesRequest) (*GetLatestCoursesResponse, error) {
	res := &GetLatestCoursesResponse{}

	data, err := s.Repository.GetCourses(ctx)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "%s", err)
	}

	for _, course := range data {
		res.Courses = append(res.Courses, &RecommendedCourse{
			CourseId: course.ID,
		})
	}

	return res, nil
}

func (s *RecommendationsServicer) GetPopularCourses(ctx context.Context, in *GetPopularCoursesRequest) (*GetPopularCoursesResponse, error) {
	res := &GetPopularCoursesResponse{}

	data, err := s.Repository.GetCourses(ctx)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "%s", err)
	}

	for _, course := range data {
		res.Courses = append(res.Courses, &RecommendedCourse{
			CourseId: course.ID,
		})
	}

	return res, nil
}
