package logging

import (
	"fmt"
	"os"
	"runtime"

	logrus "github.com/sirupsen/logrus"
)

type LogrusLogger struct {
	Logger *logrus.Logger
}

func NewLogrusLogging() Logger {
	logLevel, err := logrus.ParseLevel(os.Getenv("LOG_LEVEL"))
	if err != nil {
		logLevel = logrus.InfoLevel
	}

	l := logrus.New()
	l.SetFormatter(&CloudLoggingFormatter{})
	l.SetLevel(logLevel)

	return &LogrusLogger{Logger: l}
}

func (l *LogrusLogger) Log(level string, args ...interface{}) {
	l.Logger.WithFields(logrus.Fields{
		"severity": "INFO",
		"message":  fmt.Sprint(args...),
	}).Info()
}

func (l *LogrusLogger) Info(format string, args ...interface{}) {
	l.Logger.WithFields(logrus.Fields{
		"severity": "INFO",
		"message":  fmt.Sprintf(format, args...),
	}).Info()
}

func (l *LogrusLogger) Debug(format string, args ...interface{}) {
	l.Logger.WithFields(logrus.Fields{
		"severity": "DEBUG",
		"message":  fmt.Sprintf(format, args...),
	}).Debug()
}

func (l *LogrusLogger) Error(format string, args ...interface{}) {
	_, fn, line, _ := runtime.Caller(1)
	l.Logger.WithFields(logrus.Fields{
		"severity": "ERROR",
		"line":     fmt.Sprintf("%s:%d", fn, line),
		"message":  fmt.Sprintf(format, args...),
	}).Error()
}

func (l *LogrusLogger) Fatal(format string, args ...interface{}) {
	_, fn, line, _ := runtime.Caller(1)
	l.Logger.WithFields(logrus.Fields{
		"severity":   "ERROR",
		"line":       fmt.Sprintf("%s:%d", fn, line),
		"stackTrace": stackTrace(),
		"message":    fmt.Sprintf(format, args...),
	}).Fatal()
}

func (l *LogrusLogger) Panic(format string, args ...interface{}) {
	l.Logger.WithFields(logrus.Fields{
		"severity": "CRITICAL",
		"message":  fmt.Sprintf(format, args...),
	}).Panic()
}
