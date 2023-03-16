import scalaj.http._

// Define the API endpoint and authorization token
val apiEndpoint = "https://api.openai.com/v1/engines/davinci-codex/completions"
val authToken = "<YOUR_AUTH_TOKEN>"

// Define a function that sends a question to ChatGPT and receives an answer
def askQuestion(question: String): String = {
  val request = Http(apiEndpoint)
    .header("Content-Type", "application/json")
    .header("Authorization", s"Bearer $authToken")
    .postData(s"""{"prompt": "$question", "max_tokens": 100, "temperature": 0.7}""")
  val response = request.asString

  if (response.isError) {
    println(s"Error asking question: ${response.body}")
    ""
  } else {
    val answer = response.body.replaceAll("\\s+$", "")
    answer
  }
}

// Example usage
val question = "What is the capital of France?"
val answer = askQuestion(question)
println(s"Question: $question")
println(s"Answer: $answer")
