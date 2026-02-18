RubyLLM.configure do |config|
  config.openai_api_key = ENV['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'] || Rails.application.credentials.dig(:openai_api_key)
  # config.default_model = "gpt-4.1-nano"

  # Use the new association-based acts_as API (recommended)
  config.use_new_acts_as = true
end
