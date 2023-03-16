library(httr)

# Set up your OpenAI API key
apiKey <- "YOUR_OPENAI_API_KEY"

# Define the URL for the OpenAI API
openaiURL <- "https://api.openai.com/v1/engines/text-davinci-002/completions"

# Define the prompt for the conversation
prompt <- "Hello, I'm ChatGPT. How can I help you today?"

# Define a function to get a response from ChatGPT
getResponse <- function(prompt) {
  # Create a JSON payload
  payload <- list(
    prompt = paste(prompt, "\n\nUser:"),
    temperature = 0.5,
    max_tokens = 1024
  )
  
  # Create an HTTP request
  response <- POST(
    openaiURL,
    add_headers(Authorization = paste("Bearer", apiKey)),
    body = toJSON(payload),
    encode = "json"
  )
  
  # Handle any errors
  stop_for_status(response)
  
  # Parse the response JSON to get the response text
  responseJSON <- content(response, "text")
  responseDict <- fromJSON(responseJSON, simplifyVector = TRUE)
  choices <- responseDict$choices[[1]]
  text <- choices$text
  
  return(text)
}

# Start the conversation
while (TRUE) {
  # Prompt the user for input
  userInput <- readline(prompt = "You: ")
  
  # Generate a response from ChatGPT
  response <- getResponse(paste(prompt, userInput))
  
  # Print the response
  cat("ChatGPT: ", trimws(response), "\n")
}
