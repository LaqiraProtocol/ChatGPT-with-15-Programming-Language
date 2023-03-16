package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"
)

// Set up your OpenAI API key
const apiKey = "YOUR_OPENAI_API_KEY"

// Define the URL for the OpenAI API
const openaiUrl = "https://api.openai.com/v1/engines/text-davinci-002/completions"

// Define the prompt for the conversation
const prompt = "Hello, I'm ChatGPT. How can I help you today?"

// Define a struct to hold the response from ChatGPT
type ChatGptResponse struct {
	Text string `json:"text"`
}

// Define a function to get a response from ChatGPT
func getResponse(prompt string) (string, error) {
	// Create an HTTP client
	client := &http.Client{}

	// Create a JSON payload
	payload := map[string]interface{}{
		"prompt":      prompt,
		"temperature": 0.5,
		"max_tokens":  1024,
	}

	// Encode the payload as JSON
	payloadJson, err := json.Marshal(payload)
	if err != nil {
		return "", err
	}

	// Create an HTTP request
	req, err := http.NewRequest("POST", openaiUrl, bytes.NewBuffer(payloadJson))
	if err != nil {
		return "", err
	}

	// Set the HTTP headers
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+apiKey)

	// Send the HTTP request
	res, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer res.Body.Close()

	// Decode the HTTP response
	var response struct {
		Choices []ChatGptResponse `json:"choices"`
	}
	if err := json.NewDecoder(res.Body).Decode(&response); err != nil {
		return "", err
	}

	// Return the response text
	return response.Choices[0].Text, nil
}

func main() {
	// Start the conversation
	for {
		// Prompt the user for input
		fmt.Print("You: ")
		var userInput string
		fmt.Scanln(&userInput)

		// Generate a response from ChatGPT
		response, err := getResponse(prompt + "\n\nUser: " + userInput)
		if err != nil {
			fmt.Fprintln(os.Stderr, "Error:", err)
			continue
		}

		// Print the response
		fmt.Println("ChatGPT:", strings.TrimSpace(response))
	}
}
