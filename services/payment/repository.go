package main

type CourseRepository struct{}

type Course struct {
	Id    string
	Price float64
}

func (r *CourseRepository) GetCourse(courseId string) (*Course, error) {
	return &Course{
		Id:    courseId,
		Price: 1000,
	}, nil
}
