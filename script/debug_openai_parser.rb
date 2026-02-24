# Debug script for OpenAI recipe parser and ruby_llm config.
# Run in Rails console: load Rails.root.join("script/debug_openai_parser.rb")
#
# Or copy-paste the sections you need into `rails console`.

puts "=== 1. API key present? (ENV or Rails credentials) ==="
from_env = ENV["OPENAI_API_KEY"]
from_credentials = Rails.application.credentials.dig(:openai_api_key)
key_source = from_env.present? ? "ENV[OPENAI_API_KEY]" : (from_credentials.present? ? "Rails credentials" : "none")
key_preview = (from_env || from_credentials).to_s[0..10]
puts "  Key present? #{(from_env || from_credentials).present?}"
puts "  Key source: #{key_source}"
puts "  Key preview (first 11 chars): #{key_preview}..." if key_preview.length > 0
if from_env.blank? && from_credentials.blank?
  puts "  => Set OPENAI_API_KEY in env, or run: rails credentials:edit and add openai_api_key: sk-your-key"
else

puts "\n=== 2. RubyLLM config (what the app uses) ==="
puts "  RubyLLM.config.openai_api_key present? #{RubyLLM.config.openai_api_key.present?}"

puts "\n=== 3. Minimal RubyLLM text call (no image) ==="
begin
  response = RubyLLM.chat(model: "gpt-4o-mini").ask("Reply with exactly: OK")
  puts "  Response: #{response.content.inspect}"
  puts "  => API key is working."
rescue => e
  puts "  Error: #{e.class}: #{e.message}"
  puts "  => Fix API key or network; then retry recipe upload."
end

puts "\n=== 4. Test parser with an existing recipe image (optional) ==="
recipe_with_image = Recipe.joins(:original_image_attachment).first
if recipe_with_image
  puts "  Found recipe ##{recipe_with_image.id} with image. Run:"
  puts "    parser = OpenAiParser::ParserService.new(recipe_with_image.original_image.blob); parser.parse_recipe"
else
  puts "  No recipe with attached image. Upload one via the app, then re-run this script."
end

end
puts "\nDone."
