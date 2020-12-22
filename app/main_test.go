package main

import (
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/alicebob/miniredis/v2"
)

func TestGetConfigIfEmpty(t *testing.T) {
	key := getConfig("", "")
	if key != "" {
		t.Errorf("Unexpected return value %s", key)
	}
}

func TestGetConfig(t *testing.T) {
	os.Setenv("TEST", "TEST")

	key := getConfig("TEST", "")
	if key != "TEST" {
		t.Errorf("Unexpected return value %s", key)
	}
}

func TestGetDBNoConfig(t *testing.T) {
	defer func() { recover() }()
	getDb()
	t.Errorf("Function did not panic")
}

func TestGetDBRedisClient(t *testing.T) {
	var PASS string = "TEST"
	mr, err := miniredis.Run()
	if err != nil {
		panic(err)
	}
	mr.RequireAuth(PASS)

	os.Setenv("ERVCP_DB_HOST", mr.Host())
	os.Setenv("ERVCP_DB_PORT", mr.Port())
	os.Setenv("ERVCP_DB_PW", PASS)

	db := getDb()
	pong, err := db.Ping().Result()
	if err != nil {
		t.Errorf("Redis ping is unsuccessful: %s", pong)
	}
}

func TestHandleHealth(t *testing.T) {
	req, err := http.NewRequest("GET", "/health", nil)
	if err != nil {
		t.Fatal(err)
	}
	rr := httptest.NewRecorder()

	handler := http.HandlerFunc(handleHealth)
	handler.ServeHTTP(rr, req)

	expected := "ok\n"
	if rr.Body.String() != expected {
		t.Errorf("Unexpected handler response: %s", rr.Body.String())
	}
}

func TestHandleRootIncrement(t *testing.T) {
	var PASS string = "TEST"
	mr, err := miniredis.Run()
	if err != nil {
		panic(err)
	}
	mr.RequireAuth(PASS)

	os.Setenv("ERVCP_DB_HOST", mr.Host())
	os.Setenv("ERVCP_DB_PORT", mr.Port())
	os.Setenv("ERVCP_DB_PW", PASS)

	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}
	rr := httptest.NewRecorder()

	handler := http.HandlerFunc(handleRoot)
	handler.ServeHTTP(rr, req)

	key, err := mr.Get("count")
	if key != "1" {
		t.Errorf("Unsuccessful count increment: %s", key)
	}
}
