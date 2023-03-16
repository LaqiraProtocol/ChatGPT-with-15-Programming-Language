const readline = require("readline");
const axios = require("axios");

// Set up your OpenAI API key
const API_KEY = "YOUR_OPENAI_API_KEY";
const MODEL = "text-davinci-002";

// Define the prompt for the conversation
const prompt = "Hello, I'm ChatGPT. How can I help you today?";

// Define a function to get a response from ChatGPT
async function getResponse(prompt, model, apiKey, temperature = 0.5) {
  const response = await axios({
    method: "post",
    url: `https://api.openai.com/v1/engines/${model}/completions`,
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    },
    data: {
      prompt,
      temperature,
      max_tokens: 1024,
    },
  });
  return response.data.choices[0].text.trim();
}

// Start the conversation
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

rl.on("line", async (input) => {
  // Generate a response from ChatGPT
  const response = await getResponse(
    prompt + "\n\nUser: " + input,
    MODEL,
    API_KEY
  );

  // Print the response
  console.log("ChatGPT:", response);
});

// Prompt the user for input
rl.prompt();
