RubyLLM.configure do |config|
  # Production (e.g. Render): prefer ENV so OPENAI_API_KEY can be set without credentials.
  # Development: prefer credentials so local .env doesn't override your real key.
  config.openai_api_key = ENV["OPENAI_API_KEY"] || Rails.application.credentials.dig(:openai_api_key)

  # config.default_model = "gpt-4.1-nano"

  # Use the new association-based acts_as API (recommended)
  config.use_new_acts_as = true
end

# NOTE: trying to fix memory issue in Render: https://github.com/crmne/ruby_llm/issues/594
RubyLLM.models.refresh!
