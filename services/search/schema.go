package search

import "github.com/typesense/typesense-go/typesense/api"

type Course struct {
	Title        string  `json:"title"`
	Price        float64 `json:"price"`
	Rating       float64 `json:"rating"`
	CourseId     string  `json:"courseId"`
	Description  string  `json:"description"`
	ThumbnailUrl string  `json:"thumbnailUrl"`
}

func CreateSchema() *api.CollectionSchema {
	defaultSortingField := "rating"
	schema := &api.CollectionSchema{
		Name: "courses",
		Fields: []api.Field{
			{
				Name: "title",
				Type: "string",
			},
			{
				Name: "price",
				Type: "float",
			},
			{
				Name: "rating",
				Type: "float",
			},
			{
				Name: "description",
				Type: "string",
			},
			{
				Name: "thumbnailUrl",
				Type: "string",
			},
		},
		DefaultSortingField: &defaultSortingField,
	}
	return schema
}
