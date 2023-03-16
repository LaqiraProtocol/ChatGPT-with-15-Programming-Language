import openai
import os

# Set up your OpenAI API key
openai.api_key = os.environ["OPENAI_API_KEY"]

# Define the prompt for the conversation
prompt = "Hello, I'm ChatGPT. How can I help you today?"

# Define a function to get a response from ChatGPT
def get_response(prompt, model, temperature=0.5):
    response = openai.Completion.create(
        engine=model,
        prompt=prompt,
        max_tokens=1024,
        temperature=temperature,
    )
    return response.choices[0].text.strip()

# Start the conversation
while True:
    # Get user input
    user_input = input("You: ")

    # Generate a response from ChatGPT
    response = get_response(prompt + "\n\nUser: " + user_input, "text-davinci-002")

    # Print the response
    print("ChatGPT:", response)
