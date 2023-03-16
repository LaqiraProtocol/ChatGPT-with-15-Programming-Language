require "json"
require "net/http"

# Set up your OpenAI API key
API_KEY = "YOUR_OPENAI_API_KEY"
MODEL = "text-davinci-002"

# Define the prompt for the conversation
PROMPT = "Hello, I'm ChatGPT. How can I help you today?"

# Define a function to get a response from ChatGPT
def get_response(prompt, model, api_key, temperature = 0.5)
  uri = URI("https://api.openai.com/v1/engines/#{model}/completions")
  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{api_key}"
  }
  data = {
    prompt: prompt,
    temperature: temperature,
    max_tokens: 1024
  }
  response = Net::HTTP.post(uri, data.to_json, headers)
  JSON.parse(response.body)["choices"][0]["text"].strip
end

# Start the conversation
loop do
  # Prompt the user for input
  print "You: "
  user_input = gets.chomp

  # Generate a response from ChatGPT
  response = get_response(PROMPT + "\n\nUser: #{user_input}", MODEL, API_KEY)

  # Print the response
  puts "ChatGPT: #{response}"
end
