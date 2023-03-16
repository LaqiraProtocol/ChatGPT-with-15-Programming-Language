use LWP::UserAgent;
use JSON::XS;

# Define the API endpoint and authorization token
my $apiEndpoint = 'https://api.openai.com/v1/engines/davinci-codex/completions';
my $authToken = '<YOUR_AUTH_TOKEN>';

# Define a function that sends a question to ChatGPT and receives an answer
sub askQuestion {
  my ($question) = @_;

  my $ua = LWP::UserAgent->new;
  my $response = $ua->post(
    $apiEndpoint,
    Content_Type => 'application/json',
    Authorization => "Bearer $authToken",
    Content => encode_json({
      prompt => $question,
      max_tokens => 100,
      temperature => 0.7
    })
  );

  if ($response->is_error) {
    print "Error asking question: " . $response->status_line . "\n";
    return '';
  } else {
    my $answer = decode_json($response->decoded_content)->{choices}->[0]->{text};
    $answer =~ s/\s+$//; # Remove any trailing whitespace
    return $answer;
  }
}

# Example usage
my $question = 'What is the capital of France?';
my $answer = askQuestion($question);
print "Question: $question\n";
print "Answer: $answer\n";
