import java.net.URI
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpResponse
import java.nio.charset.StandardCharsets

object ChatGptDemo {

    // Set up your OpenAI API key
    private const val API_KEY = "YOUR_OPENAI_API_KEY"

    // Define the URL for the OpenAI API
    private const val OPENAI_URL = "https://api.openai.com/v1/engines/text-davinci-002/completions"

    // Define the prompt for the conversation
    private const val PROMPT = "Hello, I'm ChatGPT. How can I help you today?"

    // Define a function to get a response from ChatGPT
    fun getResponse(prompt: String): String {
        // Create an HTTP client
        val client = HttpClient.newBuilder().build()

        // Create a JSON payload
        val payload = "{\"prompt\": \"$prompt\", \"temperature\": 0.5, \"max_tokens\": 1024}"

        // Create an HTTP request
        val request = HttpRequest.newBuilder()
            .uri(URI.create(OPENAI_URL))
            .header("Content-Type", "application/json")
            .header("Authorization", "Bearer $API_KEY")
            .POST(HttpRequest.BodyPublishers.ofString(payload, StandardCharsets.UTF_8))
            .build()

        // Send the HTTP request
        val response = client.send(request, HttpResponse.BodyHandlers.ofString())

        // Decode the HTTP response
        val responseParts = response.body().split("\"text\": \"")
        val responseParts2 = responseParts[1].split("\"}")
        val responseText = responseParts2[0]

        // Return the response text
        return responseText
    }

    @JvmStatic
    fun main(args: Array<String>) {
        // Start the conversation
        while (true) {
            // Prompt the user for input
            print("You: ")
            val userInput = readLine()!!

            // Generate a response from ChatGPT
            val response = getResponse("$PROMPT\n\nUser: $userInput")

            // Print the response
            println("ChatGPT: ${response.trim()}")
        }
    }
}
