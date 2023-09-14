package search

import (
	context "context"
	"errors"
	"os"
	"strings"

	firebase "firebase.google.com/go/v4"
	grpc "google.golang.org/grpc"
	"google.golang.org/grpc/metadata"
)

func IsDev() bool {
	return len(os.Getenv("DEBUG")) != 0
}

func Getenv(key, fallback string) string {
	value := os.Getenv(key)
	if len(value) == 0 {
		return fallback
	}
	return value
}

type UserId string

const UserIdKey UserId = "userId"

type Authorize func(context.Context, string) (string, error)

func GetUnaryAuthorizer(authorize Authorize) grpc.UnaryServerInterceptor {
	return func(
		ctx context.Context,
		req interface{},
		info *grpc.UnaryServerInfo,
		handler grpc.UnaryHandler,
	) (resp interface{}, err error) {

		id, err := authorize(ctx, info.FullMethod)
		if err != nil {
			cctx := context.WithValue(ctx, UserIdKey, "")
			return handler(cctx, req)
		} else {
			cctx := context.WithValue(ctx, UserIdKey, id)
			return handler(cctx, req)
		}

	}
}

func FirebaseAuthorizer(ctx context.Context, _ string) (string, error) {
	app, err := firebase.NewApp(ctx, nil)
	if err != nil {
		return "", err
	}

	auth, err := app.Auth(ctx)
	if err != nil {
		return "", err
	}

	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return "", errors.New("Authorization not provided")
	}

	values := md["authorization"]

	if len(values) == 0 {
		return "", errors.New("Authorization not provided")
	}

	idToken := values[0]
	token, err := auth.VerifyIDToken(ctx, strings.Split(idToken, " ")[1])
	if err != nil {
		return "", errors.New("Could not be authorized")
	}

	return token.UID, nil
}
