#include <iostream>
#include <string>
#include <curl/curl.h>

// Define the API endpoint and authorization token
const std::string API_ENDPOINT = "https://api.openai.com/v1/engines/davinci-codex/completions";
const std::string AUTH_TOKEN = "<YOUR_AUTH_TOKEN>";

// Define a function that sends a question to ChatGPT and receives an answer
std::string ask_question(const std::string& question) {
    // Create a cURL handle
    CURL* curl = curl_easy_init();

    // Set the API endpoint URL
    curl_easy_setopt(curl, CURLOPT_URL, API_ENDPOINT.c_str());

    // Set the request headers
    struct curl_slist* headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    headers = curl_slist_append(headers, ("Authorization: Bearer " + AUTH_TOKEN).c_str());
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    // Set the request data
    std::string request_data = "{ \"prompt\": \"" + question + "\", \"max_tokens\": 100, \"temperature\": 0.7 }";
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, request_data.c_str());

    // Set the response buffer
    std::string response_buffer;
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, [](char* ptr, size_t size, size_t nmemb, void* userdata) -> size_t {
        size_t bytes = size * nmemb;
        std::string* buffer = static_cast<std::string*>(userdata);
        buffer->append(ptr, bytes);
        return bytes;
    });
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response_buffer);

    // Send the HTTP request
    CURLcode result = curl_easy_perform(curl);

    // Clean up the cURL handle and headers
    curl_easy_cleanup(curl);
    curl_slist_free_all(headers);

    // Check if the request was successful
    if (result != CURLE_OK) {
        std::cerr << "Error sending HTTP request: " << curl_easy_strerror(result) << std::endl;
        return "";
    }

    // Parse the response JSON to extract the answer
    std::string answer;
    size_t answer_start_pos = response_buffer.find("\"text\": \"") + 9;
    size_t answer_end_pos = response_buffer.find("\"", answer_start_pos);
    if (answer_start_pos != std::string::npos && answer_end_pos != std::string::npos) {
        answer = response_buffer.substr(answer_start_pos, answer_end_pos - answer_start_pos);
    }

    return answer;
}

int main() {
    // Ask a question and print the answer
    std::string question = "What is the capital of France?";
    std::string answer = ask_question(question);
    std::cout << "Question: " << question << std::endl;
    std::cout << "Answer: " << answer << std::endl;

    return 0;
}
