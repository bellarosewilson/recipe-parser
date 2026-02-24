RubyLLM.configure do |config|
  # Prefer ENV so Render/production, fall back to rails credentials if failure
  config.openai_api_key = ENV["OPENAI_API_KEY"].presence || Rails.application.credentials.dig(:openai_api_key)
  # config.default_model = "gpt-4.1-nano"

  # Use the new association-based acts_as API (recommended)
  config.use_new_acts_as = true
end
