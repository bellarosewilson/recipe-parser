RubyLLM.configure do |config|
  # Production (e.g. Render): prefer ENV so OPENAI_API_KEY can be set without credentials.
  # Development: prefer credentials so local .env doesn't override your real key.
  config.openai_api_key = if Rails.env.production?
    ENV["OPENAI_API_KEY"].presence || Rails.application.credentials.dig(:openai_api_key)
  else
    Rails.application.credentials.dig(:openai_api_key).presence || ENV["OPENAI_API_KEY"]
  end
  # config.default_model = "gpt-4.1-nano"

  # Use the new association-based acts_as API (recommended)
  config.use_new_acts_as = true
end
