### AWS S3 Setup
1. Create an S3 bucket in AWS Console
2. Create IAM user with S3 access
3. Add credentials to `.env` file or use rails:credentials 

### OpenAI Setup

1. Get API key from https://platform.openai.com
2. Add via .env or Rails credentials: `rails credentials:edit` and add `openai_api_key: sk-your-key`
3. To verify the key and parser: `rails console` then `load Rails.root.join("script/debug_openai_parser.rb")` or in codespace 'rails runner script/debug_openai_parser.rb'
4. Manual Check with Rails Console
 enter rails/console
 1.
 ENV["OPENAI_API_KEY"].present?
 RubyLLM.config.openai_api_key.present?
 2.
 RubyLLM.chat(model: "gpt-4o-mini").ask("Say OK").content
 3.
 r = Recipe.joins(:original_image_attachment).first
 parser = OpenAiParser::ParserService.new(r.original_image.blob)
 parser.parse_recipe

### References + Resources
 ## Styling
 https://flowbite.com/blocks/
 https://tailwindcss.com/plus/ui-blocks


All files are covered by the MIT license, see [LICENSE.txt](LICENSE.txt).
