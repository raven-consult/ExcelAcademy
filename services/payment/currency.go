package main

import "fmt"

type Kobo int

func GetKobo(i float64) Kobo {
	return Kobo(i) * 100
}

func (n Kobo) ToInt() int {
	return int(n)
}

// func (n Kobo) String() string {
// 	val := n.ToInt() / 100
// 	return "N" + FormatFloat(float64(val))
// }

func FormatFloat(f float64) string {
	return fmt.Sprintf("%.2f", f)
}
