package logging

import (
	"context"
	"fmt"
	"runtime"

	"cloud.google.com/go/logging"
)

type CloudLogging struct {
	Logger *logging.Logger
}

func NewCloudLogging(name, projectID string) (*CloudLogging, error) {
	ctx := context.Background()
	client, err := logging.NewClient(ctx, projectID)
	if err != nil {
		return nil, err
	}

	return &CloudLogging{Logger: client.Logger(name)}, nil
}

func (l *CloudLogging) Log(level string, args ...interface{}) {
	l.Logger.Log(logging.Entry{
		Severity: logging.Info,
		Payload:  fmt.Sprint(args...),
	})
}

func (l *CloudLogging) Info(format string, args ...interface{}) {
	l.Logger.Log(logging.Entry{
		Severity: logging.Info,
		Payload:  fmt.Sprintf(format, args...),
	})
}

func (l *CloudLogging) Debug(format string, args ...interface{}) {
	l.Logger.Log(logging.Entry{
		Severity: logging.Debug,
		Payload:  fmt.Sprintf(format, args...),
	})
}

func (l *CloudLogging) Error(format string, args ...interface{}) {
	_, fn, line, _ := runtime.Caller(1)
	l.Logger.Log(logging.Entry{
		Severity: logging.Error,
		Payload: map[string]string{
			"line":    fmt.Sprintf("%s:%d", fn, line),
			"message": fmt.Sprintf(format, args...),
		},
	})
}

func (l *CloudLogging) Fatal(format string, args ...interface{}) {
	_, fn, line, _ := runtime.Caller(1)
	l.Logger.Log(logging.Entry{
		Severity: logging.Critical,
		Payload: map[string]string{
			"line":       fmt.Sprintf("%s:%d", fn, line),
			"stackTrace": stackTrace(),
			"message":    fmt.Sprintf(format, args...),
		},
	})
	panic(fmt.Sprintf(format, args...))
}

func (l *CloudLogging) Panic(format string, args ...interface{}) {
	l.Logger.Log(logging.Entry{
		Severity: logging.Emergency,
		Payload: map[string]string{
			"message": fmt.Sprintf(format, args...),
		},
	})
	panic(fmt.Sprintf(format, args...))
}
