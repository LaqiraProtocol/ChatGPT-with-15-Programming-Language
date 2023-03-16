import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class ChatGptDemo {

    // Set up your OpenAI API key
    private static final String API_KEY = "YOUR_OPENAI_API_KEY";

    // Define the URL for the OpenAI API
    private static final String OPENAI_URL = "https://api.openai.com/v1/engines/text-davinci-002/completions";

    // Define the prompt for the conversation
    private static final String PROMPT = "Hello, I'm ChatGPT. How can I help you today?";

    // Define a function to get a response from ChatGPT
    public static String getResponse(String prompt) throws IOException, InterruptedException {
        // Create an HTTP client
        HttpClient client = HttpClient.newHttpClient();

        // Create a JSON payload
        String payload = String.format("{\"prompt\": \"%s\", \"temperature\": 0.5, \"max_tokens\": 1024}", prompt);

        // Create an HTTP request
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(OPENAI_URL))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + API_KEY)
                .POST(HttpRequest.BodyPublishers.ofString(payload, StandardCharsets.UTF_8))
                .build();

        // Send the HTTP request
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        // Decode the HTTP response
        String[] responseParts = response.body().split("\"text\": \"");
        String[] responseParts2 = responseParts[1].split("\"}");
        String responseText = responseParts2[0];

        // Return the response text
        return responseText;
    }

    public static void main(String[] args) throws IOException, InterruptedException {
        // Start the conversation
        while (true) {
            // Prompt the user for input
            System.out.print("You: ");
            String userInput = System.console().readLine();

            // Generate a response from ChatGPT
            String response = getResponse(PROMPT + "\n\nUser: " + userInput);

            // Print the response
            System.out.println("ChatGPT: " + response.trim());
        }
    }
}
