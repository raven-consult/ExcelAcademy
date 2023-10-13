package logging

import (
	"fmt"
	"os"
)

type Logger interface {
	Log(level string, args ...interface{})
	Info(format string, args ...interface{})
	Error(format string, args ...interface{})
	Fatal(format string, args ...interface{})
	Panic(format string, args ...interface{})
	Debug(format string, args ...interface{})
}

var DEBUG bool = os.Getenv("DEBUG") != ""

func SetupLogging(name, projectID string) Logger {
	var handler Logger
	var err error
	if DEBUG {
		handler = NewLogrusLogging()
	} else {
		handler, err = NewCloudLogging(name, projectID)
		if err != nil {
			fmt.Println("Error")
			panic(err)
		}
	}
	return handler
}
