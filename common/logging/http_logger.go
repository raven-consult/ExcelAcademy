package logging

import (
	"net/http"
	"time"

	log "github.com/sirupsen/logrus"
)

type (
	// struct for holding response details
	responseData struct {
		status int
		size   int
	}

	// our http.ResponseWriter implementation
	loggingResponseWriter struct {
		http.ResponseWriter // compose original http.ResponseWriter
		responseData        *responseData
	}
)

func (r *loggingResponseWriter) Write(b []byte) (int, error) {
	size, err := r.ResponseWriter.Write(b) // write response using original http.ResponseWriter
	r.responseData.size += size            // capture size
	return size, err
}

func (r *loggingResponseWriter) WriteHeader(statusCode int) {
	r.ResponseWriter.WriteHeader(statusCode) // write status code using original http.ResponseWriter
	r.responseData.status = statusCode       // capture status code
}

func WithLogging(h http.Handler) http.Handler {
	loggingFn := func(rw http.ResponseWriter, req *http.Request) {
		start := time.Now()

		responseData := &responseData{
			status: 0,
			size:   0,
		}
		lrw := loggingResponseWriter{
			ResponseWriter: rw, // compose original http.ResponseWriter
			responseData:   responseData,
		}
		h.ServeHTTP(&lrw, req) // inject our implementation of http.ResponseWriter

		duration := time.Since(start)

		log.WithFields(log.Fields{
			"duration": duration,
			"method":   req.Method,
			"uri":      req.RequestURI,
			"size":     responseData.size,
			"status":   responseData.status,
		}).Info("request completed")
	}
	return http.HandlerFunc(loggingFn)
}
