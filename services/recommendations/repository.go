package main

import (
	"context"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/db"
)

const (
	paginationSize = 10
)

type Course struct {
	ID                string `json:"id"`
	NumOfEnrollements int    `json:"numOfEnrollements"`
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

type Repository struct {
	Database *db.Client
}

func (r *Repository) GetCourses(ctx context.Context) ([]*Course, error) {
	// Get the courses from the database
	courses := []*Course{}

	results, err := r.Database.NewRef("courses").
		OrderByChild("numOfEnrollements").
		LimitToLast(paginationSize).
		GetOrdered(ctx)

	if err != nil {
		return nil, err
	}

	for _, result := range results {
		var course Course
		if err := result.Unmarshal(&course); err != nil {
			return nil, err
		}
		courses = append(courses, &course)
	}
	return courses, nil
}

func (r *Repository) IncrementCourseEnrollements(ctx context.Context, courseID string) error {
	// Get the course from the database
	course, err := r.GetCourse(ctx, courseID)
	if err != nil {
		return err
	}

	// Increment the number of enrollements
	course.NumOfEnrollements++

	// Update the course in the database
	err = r.UpdateCourse(ctx, course)
	if err != nil {
		return err
	}

	return nil
}

func (r *Repository) GetCourse(ctx context.Context, courseID string) (*Course, error) {
	// Get the course from the database
	course := &Course{}

	if err := r.Database.NewRef("courses/"+courseID).Get(ctx, &course); err != nil {
		return nil, err
	}

	return course, nil
}

func (r *Repository) UpdateCourse(ctx context.Context, course *Course) error {
	// Update the course in the database
	if err := r.Database.NewRef("courses/"+course.ID).Set(ctx, course); err != nil {
		return err
	}

	return nil
}
