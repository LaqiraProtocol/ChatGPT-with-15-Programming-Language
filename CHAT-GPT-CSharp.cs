using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace ChatGptDemo
{
    class Program
    {
        // Set up your OpenAI API key
        private const string API_KEY = "YOUR_OPENAI_API_KEY";

        // Define the URL for the OpenAI API
        private const string OPENAI_URL = "https://api.openai.com/v1/engines/text-davinci-002/completions";

        // Define the prompt for the conversation
        private const string PROMPT = "Hello, I'm ChatGPT. How can I help you today?";

        // Define a function to get a response from ChatGPT
        static async Task<string> GetResponse(string prompt)
        {
            // Create an HTTP client
            var client = new HttpClient();

            // Create a JSON payload
            var payload = $"{{\"prompt\": \"{prompt}\", \"temperature\": 0.5, \"max_tokens\": 1024}}";

            // Create an HTTP request
            var request = new HttpRequestMessage
            {
                RequestUri = new Uri(OPENAI_URL),
                Method = HttpMethod.Post,
                Headers =
                {
                    { "Content-Type", "application/json" },
                    { "Authorization", $"Bearer {API_KEY}" }
                },
                Content = new StringContent(payload, Encoding.UTF8, "application/json")
            };

            // Send the HTTP request and get the response
            var response = await client.SendAsync(request);
            var responseContent = await response.Content.ReadAsStringAsync();

            // Decode the response JSON to get the response text
            var responseText = responseContent.Split("\"text\": \"")[1].Split("\"}")[0];

            // Return the response text
            return responseText;
        }

        static void Main(string[] args)
        {
            // Start the conversation
            while (true)
            {
                // Prompt the user for input
                Console.Write("You: ");
                var userInput = Console.ReadLine();

                // Generate a response from ChatGPT
                var response = GetResponse($"{PROMPT}\n\nUser: {userInput}").Result;

                // Print the response
                Console.WriteLine($"ChatGPT: {response.Trim()}");
            }
        }
    }
}
