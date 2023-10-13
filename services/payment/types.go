package main

type InitializeRequest struct {
	UserID       string   `json:"userId"`
	CourseIDs    []string `json:"courseIds"`
	DiscountCode string   `json:"discountCode,omitempty"`
}

type InitializeResponse struct {
	Reference  string `json:"reference"`
	AccessCode string `json:"accessCode"`
}

type VerifyRequest struct {
	Reference string `json:"reference"`
}

type VerifyResponse struct {
	Status    string `json:"status"`
	Reference string `json:"reference"`
}

type ValidateDiscountRequest struct {
	CourseIDs    []string `json:"courseIds"`
	DiscountCode string   `json:"discountCode"`
}

type ValidateDiscountResponse struct {
	Valid           bool    `json:"valid"`
	ResultantAmount string  `json:"resultantAmount"`
}

type PaystackInitializeRequest struct {
	Email     string `json:"email"`
	Amount    int    `json:"amount"`
	Reference string `json:"reference"`
}

type PaystackInitializeData struct {
	Status  bool   `json:"status"`
	Message string `json:"message"`
	Data    struct {
		Reference        string `json:"reference"`
		AccessCode       string `json:"access_code"`
		AuthorizationURL string `json:"authorization_url"`
	} `json:"data"`
}

type PaystackVerifyData struct {
	Status  bool   `json:"status"`
	Message string `json:"message"`
	Data    struct {
		Amount    int    `json:"amount"`
		Status    string `json:"status"`
		Reference string `json:"reference"`
	}
}
