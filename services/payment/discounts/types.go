package discounts

import "time"

type DiscountKind interface {
	Apply(amount float64) (float64, error)
}

type Discount struct {
	Code      string
	UserIds   []string
	CourseIds []string
	ExpiresAt time.Time
	Kind      DiscountKind
}
