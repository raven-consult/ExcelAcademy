package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"

	"firebase.google.com/go/v4/auth"
	log "github.com/sirupsen/logrus"

	"excel_academy/services/payment/discounts"
)

const (
	PAYSTACK_BASE_URL = "https://api.paystack.co"
)

type PaymentService struct {
	SecretKey    string
	CourseRepo   *CourseRepository
	DiscountRepo *discounts.DiscountRepository
}

func (s *PaymentService) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	if r.URL.Path == "/initialize" {
		s.handleInitialize(ctx, w, r)
	} else if r.URL.Path == "/verify" {
		s.handleVerify(ctx, w, r)
	} else if r.URL.Path == "/validateDiscount" {
		s.handleValidateDiscount(ctx, w, r)
	} else {
		w.WriteHeader(http.StatusNotFound)
		fmt.Fprintf(w, "not found")
	}
}

func (s *PaymentService) handleValidateDiscount(ctx context.Context, w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	body := ValidateDiscountRequest{}
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		log.Error(fmt.Sprintf("error decoding request body: %v", err))
		http.Error(w, fmt.Sprintf("error decoding request body: %v", err), http.StatusBadRequest)
		return
	}

	discount, err := s.DiscountRepo.CheckDiscountCode(r.Context(), body.DiscountCode, &body.CourseIDs)
	if err != nil {
		log.Error(fmt.Sprintf("error checking discount code: %v", err))
		http.Error(w, fmt.Sprintf("error checking discount code: %v", err), http.StatusInternalServerError)
		return
	}

	amount := 0.0

	for _, courseID := range body.CourseIDs {
		course, err := s.CourseRepo.GetCourse(courseID)
		if err != nil {
			log.Error(fmt.Sprintf("error getting course: %v", err))
			http.Error(w, fmt.Sprintf("error getting course: %v", err), http.StatusInternalServerError)
			return
		}
		amount += course.Price
	}

	res := &ValidateDiscountResponse{
		Valid:           discount != nil,
		ResultantAmount: fmt.Sprintf("%.2f", amount),
	}

	discountData, err := json.Marshal(res)
	if err != nil {
		log.Error(fmt.Sprintf("error marshalling discount: %v", err))
		http.Error(w, fmt.Sprintf("error marshalling discount: %v", err), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(discountData)
}

func (s *PaymentService) handleInitialize(ctx context.Context, w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	body := InitializeRequest{}
	err := json.NewDecoder(r.Body).Decode(&body)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		log.Error(fmt.Sprintf("error decoding request body: %v", err))
		fmt.Fprintf(w, "error decoding request body: %v", err)
		return
	}

	amount := 0

	for _, courseID := range body.CourseIDs {
		course, err := s.CourseRepo.GetCourse(courseID)
		if err != nil {
			log.Error(fmt.Sprintf("error getting course: %v", err))
			http.Error(w, fmt.Sprintf("error getting course: %v", err), http.StatusInternalServerError)
			return
		}
		amount += int(course.Price)
	}

	email := ""
	user := r.Context().Value("user").(*auth.UserRecord)
	if user != nil {
		fmt.Println("user is not nil", user)
		email = user.Email
	}

	paystackReq := PaystackInitializeRequest{
		Email:  email,
		Amount: amount,
	}

	if body.DiscountCode != "" {
		discount, err := s.DiscountRepo.CheckDiscountCode(r.Context(), body.DiscountCode, &body.CourseIDs)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			log.Error(fmt.Sprintf("error checking discount code: %v", err))
			fmt.Fprintf(w, "error checking discount code: %v", err)
			return
		}
		appliedAmount, err := s.DiscountRepo.ApplyDiscount(discount, float64(paystackReq.Amount))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			log.Error(fmt.Sprintf("error applying discount: %v", err))
			fmt.Fprintf(w, "error applying discount: %v", err)
			return
		}
		paystackReq.Amount = int(appliedAmount)
	}

	// Convert amount to kobo
	paystackReq.Amount = paystackReq.Amount * 100

	bodyData, err := json.Marshal(paystackReq)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		log.Error(fmt.Sprintf("error marshalling request body: %v", err))
		fmt.Fprintf(w, "error marshalling request body: %v", err)
		return
	}

	client, err := http.NewRequest("POST", PAYSTACK_BASE_URL+"/transaction/initialize", bytes.NewBuffer(bodyData))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Error(fmt.Sprintf("error creating request: %v", err))
		fmt.Fprintf(w, "error creating request: %v", err)
		return
	}

	client.Header.Set("Content-Type", "application/json")
	client.Header.Set("Authorization", "Bearer "+s.SecretKey)

	resp, err := http.DefaultClient.Do(client)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Error(err)
		fmt.Fprintf(w, "error making request: %v", err)
		return
	}

	defer resp.Body.Close()

	res := PaystackInitializeData{}
	err = json.NewDecoder(resp.Body).Decode(&res)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Error(fmt.Sprintf("error decoding response body: %v", err))
		fmt.Fprintf(w, "error decoding response body: %v", err)
		return
	}

	data := &InitializeResponse{
		Reference:  res.Data.Reference,
		AccessCode: res.Data.AccessCode,
	}

	resJson, err := json.Marshal(data)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Error(fmt.Sprintf("error marshalling response body: %v", err))
		fmt.Fprintf(w, "error marshalling response body: %v", err)
		return
	}

	w.WriteHeader(http.StatusOK)
	_, err = w.Write(resJson)
	if err != nil {
		log.Error(fmt.Sprintf("error writing response body: %v", err))
	}
}

func (s *PaymentService) handleVerify(ctx context.Context, w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	body := VerifyRequest{}
	err := json.NewDecoder(r.Body).Decode(&body)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		log.Error(fmt.Sprintf("error decoding request body: %v", err))
		fmt.Fprintf(w, "error decoding request body: %v", err)
		return
	}

	client, err := http.NewRequest("GET", PAYSTACK_BASE_URL+"/transaction/verify/"+body.Reference, nil)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "error creating request: %v", err)
		log.Error(fmt.Sprintf("error creating request: %v", err))
		return
	}

	client.Header.Set("Content-Type", "application/json")
	client.Header.Set("Authorization", "Bearer "+s.SecretKey)

	resp, err := http.DefaultClient.Do(client)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "error making request: %v", err)
		log.Error(fmt.Sprintf("error making request: %v", err))
		return
	}

	defer resp.Body.Close()

	res := PaystackVerifyData{}
	err = json.NewDecoder(resp.Body).Decode(&res)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "error decoding response body: %v", err)
		log.Error(fmt.Sprintf("error decoding response body: %v", err))
		return
	}

	data := &VerifyResponse{
		Status:    res.Data.Status,
		Reference: res.Data.Reference,
	}

	resJson, err := json.Marshal(data)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "error marshalling response body: %v", err)
		log.Error(fmt.Sprintf("error marshalling response body: %v", err))
		return
	}

	w.WriteHeader(http.StatusOK)
	_, err = w.Write(resJson)
	if err != nil {
		log.Error(fmt.Sprintf("error writing response body: %v", err))
	}
}
