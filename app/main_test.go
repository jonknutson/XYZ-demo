package main

import (
	"os"
	"regexp"
	"testing"
)

// TestNoPortEnv calls getHostAddress with no value set
// for ENV xyzAppPort, checking for return value of
// "localhost:8080".
func TestNoPortEnv(t *testing.T) {
	os.Unsetenv("XYZ_APP_PORT")
	want := regexp.MustCompile("0.0.0.0:8080")
	msg := getHostAddress()
	if !want.MatchString(msg) {
		t.Fatalf(`getHostAddress() without XYZ_APP_PORT set = %q, want match for %#q`, msg, want)
	}
}

// TestPortEnv80 calls getHostAddress with ENV XYZ_APP_PORT set
// to 80, checking for a return value of "localhost:80"
func TestPortEnv80(t *testing.T) {
	os.Setenv("XYZ_APP_PORT", "80")
	want := regexp.MustCompile("0.0.0.0:80")
	msg := getHostAddress()
	if !want.MatchString(msg) {
		t.Fatalf(`getHostAddress() with XYZ_APP_PORT set to 80 = %q, want match for %#q`, msg, want)
	}
}
