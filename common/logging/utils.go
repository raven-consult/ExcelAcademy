package logging

import (
	"fmt"
	"runtime"
	"strings"
)

func join(sep string, values []interface{}) string {
	strs := make([]string, len(values))
	for i, v := range values {
		strs[i] = fmt.Sprintf("%s", v)
	}
	return strings.Join(strs, sep)
}

func stackTrace() string {
	b := make([]byte, 2048) // adjust buffer size to be larger than expected stack
	n := runtime.Stack(b, false)
	s := string(b[:n])
	return s
}
