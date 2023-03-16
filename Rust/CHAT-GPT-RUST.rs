use reqwest::header::{HeaderMap, AUTHORIZATION, CONTENT_TYPE};
use serde::{Deserialize, Serialize};
use std::io::{stdin, stdout, Write};

// Set up your OpenAI API key
const API_KEY: &str = "YOUR_OPENAI_API_KEY";
const MODEL: &str = "text-davinci-002";

// Define the prompt for the conversation
const PROMPT: &str = "Hello, I'm ChatGPT. How can I help you today?";

// Define a struct to hold the response from ChatGPT
#[derive(Debug, Deserialize)]
struct ChatGptResponse {
    text: String,
}

// Define a function to get a response from ChatGPT
async fn get_response(prompt: &str, model: &str, api_key: &str, temperature: f64) -> String {
    let client = reqwest::Client::new();
    let mut headers = HeaderMap::new();
    headers.insert(CONTENT_TYPE, "application/json".parse().unwrap());
    headers.insert(AUTHORIZATION, format!("Bearer {}", api_key).parse().unwrap());
    let data = format!(
        r#"{{"prompt":"{}","temperature":{},"max_tokens":1024}}"#,
        prompt, temperature
    );
    let response = client
        .post(&format!(
            "https://api.openai.com/v1/engines/{}/completions",
            model
        ))
        .headers(headers)
        .body(data)
        .send()
        .await
        .unwrap()
        .json::<Vec<ChatGptResponse>>()
        .await
        .unwrap();
    response[0].text.trim().to_string()
}

#[tokio::main]
async fn main() {
    // Start the conversation
    loop {
        // Prompt the user for input
        print!("You: ");
        stdout().flush().unwrap();
        let mut user_input = String::new();
        stdin().read_line(&mut user_input).unwrap();

        // Generate a response from ChatGPT
        let response = get_response(
            &(PROMPT.to_owned() + "\n\nUser: " + &user_input),
            MODEL,
            API_KEY,
            0.5,
        )
        .await;

        // Print the response
        println!("ChatGPT: {}", response);
    }
}
