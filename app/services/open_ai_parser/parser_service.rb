module OpenAiParser
  class ParserService
    RECIPE_JSON_PROMPT = <<~PROMPT
      Look at this recipe image and extract the recipe data.

      Preferred units for amounts: %<units>s — use metric (g, ml, etc.) when "metric", imperial (cups, tbsp, etc.) when "imperial".

      Return a single JSON object with exactly these keys (no other keys):
      - "title": string — the recipe name
      - "ingredients": array of objects, each with: "amount" (string), "name" (string), "unit" (string)
      - "steps": array of objects, each with: "position" (string: "1", "2", "3", ...), "instruction" (string — full step text)

      Use valid JSON only. No markdown, no code fences.
    PROMPT

    def initialize(image_source, preferred_units = nil)
      @image_source = image_source
      @preferred_units = preferred_units.presence || "metric"
    end

    def parse_recipe
      image_ref = resolve_image_ref
      raise ArgumentError, "No valid image source (pass an ActiveStorage::Blob, URL, or file path)" if image_ref.blank?

      prompt = format(RECIPE_JSON_PROMPT, units: @preferred_units)

      chat = RubyLLM.chat(model: vision_model)
        .with_instructions("You are a precise recipe extractor. Return only valid JSON with the exact keys requested.")
        .with_temperature(0.2)
        .with_params(response_format: { type: "json_object" })

      response = chat.ask(prompt, with: image_ref)
      raw = response.content

      json_str = raw.strip.sub(/\A```(?:json)?\s*/, "").sub(/\s*```\z/, "").strip
      data = JSON.parse(json_str)

      if Rails.env.development?
        ing = data["ingredients"]
        st = data["steps"]
        Rails.logger.info "[OpenAiParser] API top-level keys: #{data.keys.inspect}"
        Rails.logger.info "[OpenAiParser] ingredients: #{ing.class} size=#{ing.respond_to?(:size) ? ing.size : "n/a"} first=#{ing.is_a?(Array) && ing.any? ? ing.first.inspect : "n/a"}"
        Rails.logger.info "[OpenAiParser] steps: #{st.class} size=#{st.respond_to?(:size) ? st.size : "n/a"} first=#{st.is_a?(Array) && st.any? ? st.first.inspect : "n/a"}"
      end

      {
        title: normalize_title(data["title"]),
        ingredients: indexed_attributes(normalize_ingredients(data["ingredients"])),
        steps: indexed_attributes(normalize_steps(data["steps"]))
      }
    ensure
      @tempfile&.close
      @tempfile&.unlink
    end

    private

    def vision_model
      # Prefer a vision-capable model; gpt-4o and gpt-4o-mini support images and analysis
      "gpt-4o"
    end

    def resolve_image_ref
      case @image_source
      when ActiveStorage::Blob
        blob_to_tempfile(@image_source)
      when String
        if @image_source.start_with?("http://", "https://")
          @image_source
        else
          Pathname.new(@image_source).expand_path.to_s if File.exist?(@image_source)
        end
      end
    end

    def blob_to_tempfile(blob)
      @tempfile = Tempfile.new([ "recipe_image", blob.filename.extension_with_delimiter ])
      @tempfile.binmode
      blob.download { |chunk| @tempfile.write(chunk) }
      @tempfile.rewind
      @tempfile.path
    end

    def normalize_title(value)
      value.to_s.strip.presence || "Untitled Recipe"
    end

    def normalize_ingredients(list)
      return [] unless list.is_a?(Array)

      list.each_with_index.map do |item, index|
        next unless item.is_a?(Hash)

        {
          amount: item["amount"].to_s.strip.presence || "—",
          name: item["name"].to_s.strip.presence || "—",
          unit: item["unit"].to_s.strip.presence || "—"
        }
      end.compact
    end

    def normalize_steps(list)
      return [] unless list.is_a?(Array)

      list.each_with_index.map do |item, index|
        next unless item.is_a?(Hash)

        pos = item["position"].to_s.strip.presence || (index + 1).to_s
        instruction = item["instruction"].to_s.strip.presence || "—"
        { position: pos, instruction: instruction }
      end.compact
    end

    # Rails nested attributes expect indexed hash: { "0" => {...}, "1" => {...} }
    def indexed_attributes(array_of_hashes)
      array_of_hashes.each_with_index.to_h { |attrs, i| [ i.to_s, attrs ] }
    end
  end
end
