import Foundation

// Set up your OpenAI API key
let apiKey = "YOUR_OPENAI_API_KEY"

// Define the URL for the OpenAI API
let openaiURL = URL(string: "https://api.openai.com/v1/engines/text-davinci-002/completions")!

// Define the prompt for the conversation
let prompt = "Hello, I'm ChatGPT. How can I help you today?"

// Define a function to get a response from ChatGPT
func getResponse(prompt: String, completionHandler: @escaping (String?, Error?) -> Void) {
    // Create a JSON payload
    let payload = """
        {
            "prompt": "\(prompt)\n\nUser:",
            "temperature": 0.5,
            "max_tokens": 1024
        }
        """
    
    // Create an HTTP request
    var request = URLRequest(url: openaiURL)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.httpBody = payload.data(using: .utf8)
    
    // Send the HTTP request and get the response
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        // Handle any errors
        guard error == nil else {
            completionHandler(nil, error)
            return
        }
        
        // Parse the response JSON to get the response text
        if let data = data,
           let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
           let responseDict = responseJSON as? [String: Any],
           let choices = responseDict["choices"] as? [[String: Any]],
           let text = choices.first?["text"] as? String {
            completionHandler(text, nil)
        } else {
            completionHandler(nil, NSError(domain: "ChatGPTError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response."]))
        }
    }
    task.resume()
}

// Start the conversation
while true {
    // Prompt the user for input
    print("You: ", terminator: "")
    let userInput = readLine() ?? ""
    
    // Generate a response from ChatGPT
    getResponse(prompt: "\(prompt)\n\nUser: \(userInput)") { response, error in
        // Handle any errors
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        // Print the response
        print("ChatGPT: \(response?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")")
    }
}
