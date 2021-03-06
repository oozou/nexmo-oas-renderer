# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class BlockEscape < Banzai::Filter
          def call(input)
            # Freeze to prevent Markdown formatting
            input.gsub(/````\n(.+?)````/m) do |_s|
              lexer = Rouge::Lexer.find('text')
              formatter = Rouge::Formatters::HTML.new
              highlighted_source = formatter.format(lexer.lex(Regexp.last_match(1)))

              output = <<~HEREDOC
                <pre class="highlight #{lexer.tag}"><code>#{highlighted_source}</code></pre>
              HEREDOC

              "FREEZESTART#{Base64.urlsafe_encode64(output)}FREEZEEND"
            end
          end
        end
      end
    end
  end
end
