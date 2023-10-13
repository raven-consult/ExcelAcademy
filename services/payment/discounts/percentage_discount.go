package discounts

func GetDiscountKind(kind string) DiscountKind {
	switch kind {
	case PercentageDiscountKind:
		return &PercentageDiscount{}
	case FixedDiscountKind:
		return &FixedDiscount{}
	default:
		return nil
	}
}

const PercentageDiscountKind = "percentage"

type PercentageDiscount struct {
	Percentage float64
}

func (d *PercentageDiscount) Apply(amount float64) (float64, error) {
	res := amount - (amount * d.Percentage)
	return res, nil
}

const FixedDiscountKind = "fixed"

type FixedDiscount struct {
	Amount float64
}

func (d *FixedDiscount) Apply(amount float64) (float64, error) {
	res := amount - d.Amount
	return res, nil
}
