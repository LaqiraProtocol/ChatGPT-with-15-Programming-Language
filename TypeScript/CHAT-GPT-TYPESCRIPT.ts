import axios from 'axios';

// Define the API endpoint and authorization token
const API_ENDPOINT = 'https://api.openai.com/v1/engines/davinci-codex/completions';
const AUTH_TOKEN = '<YOUR_AUTH_TOKEN>';

// Define a function that sends a question to ChatGPT and receives an answer
async function askQuestion(question: string): Promise<string> {
  try {
    // Send the HTTP request to the OpenAI API
    const response = await axios.post(API_ENDPOINT, {
      prompt: question,
      max_tokens: 100,
      temperature: 0.7
    }, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${AUTH_TOKEN}`
      }
    });

    // Extract the answer from the response data
    const answer = response.data.choices[0].text.trim();

    return answer;
  } catch (error) {
    console.error(`Error asking question: ${error.message}`);
    return '';
  }
}

// Example usage
(async () => {
  const question = 'What is the capital of France?';
  const answer = await askQuestion(question);
  console.log(`Question: ${question}`);
  console.log(`Answer: ${answer}`);
})();
