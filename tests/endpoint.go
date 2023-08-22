package test

import (
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
)

type Endpoint struct {
	url             string
	expectedStrings []string
}

var endpoints = []Endpoint{
	{
		url: "https://nextjs-grpc.utkusarioglu.com/api/v1/data/inflation/decade-stats?codes=TUR,USA",
		expectedStrings: []string{
			"payload",
			// These two mean that there is the chain reaching
			// `postgres-storage` works
			"Turkiye",
			"United States",
			"creator",
			"profileImage",
			"utku",
		},
	},
	{
		url: "https://nextjs-grpc.utkusarioglu.com/api/v1/data/inflation/decade-stats?codes=TUR",
		expectedStrings: []string{
			"payload",
			// This means that there is the chain reaching
			// `postgres-storage` works
			"Turkiye",
			"creator",
			"profileImage",
			"utku",
		},
	},
	{
		url: "https://nextjs-grpc.utkusarioglu.com/api/v1/data/inflation/decade-stats?codes=USA",
		expectedStrings: []string{
			"payload",
			// This means that there is the chain reaching
			// `postgres-storage` works
			"United States",
			"creator",
			"profileImage",
			"utku",
		},
	},
	// {
	// 	url:             "https://jaeger.nextjs-grpc.utkusarioglu.com",
	// 	expectedStrings: []string{"jaeger"},
	// },
	// {
	// 	url:             "https://grafana.nextjs-grpc.utkusarioglu.com",
	// 	expectedStrings: []string{"Grafana"},
	// },
	// {
	// 	url:             "https://kubernetes-dashboard.nextjs-grpc.utkusarioglu.com",
	// 	expectedStrings: []string{"Kubernetes Dashboard"},
	// },
	// {
	// 	url:             "https://prometheus.nextjs-grpc.utkusarioglu.com",
	// 	expectedStrings: []string{"Prometheus"},
	// },
	{
		url:             "https://vault.nextjs-grpc.utkusarioglu.com:8200",
		expectedStrings: []string{"Vault"},
	},
}

func EndpointTests(t *testing.T) func() {
	return func() {
		for _, props := range endpoints {
			http_helper.HttpGetWithRetryWithCustomValidation(
				t,
				props.url,
				nil,
				3,
				5*time.Second,
				func(code int, response string) bool {
					passing := true
					if code < 200 || code >= 300 {
						passing = false
					}
					for _, expectedString := range props.expectedStrings {
						lengthCorrect := len(response) > 0
						containsExpected := strings.Contains(response, expectedString)
						wordTest := lengthCorrect && containsExpected
						passing = passing && wordTest
					}
					return passing
				},
			)
		}
	}
}
