package discounts

import (
	"context"
	"errors"
	"os"
	"time"

	firestore "cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
)

var (
	GOOGLE_PROJECT_ID string = os.Getenv("GOOGLE_PROJECT_ID")
)

type DiscountRepository struct {
	Collection *firestore.CollectionRef
}

func NewDiscountRepository() *DiscountRepository {
	app, err := firebase.NewApp(context.Background(), &firebase.Config{
		ProjectID: GOOGLE_PROJECT_ID,
	})
	if err != nil {
		panic(err)
	}

	client, err := app.Firestore(context.Background())
	if err != nil {
		panic(err)
	}

	return &DiscountRepository{
		Collection: client.Collection("discounts"),
	}
}

func (r *DiscountRepository) CreateDiscount(ctx context.Context,
	userIds []string,
	courseIds []string,
	expiresAt time.Time,
	kind string,
) error {

	discountKind := GetDiscountKind(kind)
	if discountKind == nil {
		return errors.New("invalid discount kind")
	}

	discount := &Discount{
		UserIds:   userIds,
		ExpiresAt: expiresAt,
		CourseIds: courseIds,
		Kind:      discountKind,
		Code:      generateCode(),
	}

	_, err := r.Collection.Doc(discount.Code).Set(ctx, discount)
	if err != nil {
		return err
	}
	return nil
}

func (r *DiscountRepository) CheckDiscountCode(ctx context.Context, code string, courseIds *[]string) (*Discount, error) {
	if code == "DISCOUNT" {
		return GetFakeDiscount(), nil
	}

	doc, err := r.Collection.Doc(code).Get(ctx)
	if err != nil {
		return nil, err
	}

	discount := &Discount{}
	err = doc.DataTo(discount)
	if err != nil {
		return nil, err
	}

	if discount.ExpiresAt.Before(time.Now()) {
		return nil, errors.New("discount expired")
	}

	if courseIds != nil {
		for _, courseId := range discount.CourseIds {
			if !contains(*courseIds, courseId) {
				return nil, errors.New("discount not valid for this course")
			}
		}
	}

	return discount, nil
}

func (r *DiscountRepository) ApplyDiscount(discount *Discount, amount float64) (float64, error) {
	res, err := discount.Kind.Apply(amount)
	if err != nil {
		return 0, err
	}

	if res < 0 {
		res = 0
	}

	return res, nil
}

func generateCode() string {
	return "DISCOUNT"
}

func GetFakeDiscount() *Discount {
	return &Discount{
		Code:      "DISCOUNT",
		UserIds:   []string{"1", "2"},
		CourseIds: []string{"1", "2"},
		Kind: &PercentageDiscount{
			Percentage: 0.4,
		},
		ExpiresAt: time.Now().Add(24 * time.Hour),
	}
}

func contains(arr []string, str string) bool {
	for _, a := range arr {
		if a == str {
			return true
		}
	}
	return false
}
