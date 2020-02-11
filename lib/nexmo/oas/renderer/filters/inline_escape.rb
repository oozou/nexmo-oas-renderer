# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class InlineEscape < Banzai::Filter
          def call(input)
            # Freeze to prevent Markdown formatting
            input.gsub(/``(.+?)``/) do |_s|
              frozen_code = Base64.urlsafe_encode64("<code>#{Regexp.last_match(1)}</code>")
              "FREEZESTART#{frozen_code}FREEZEEND"
            end
          end
        end
      end
    end
  end
end
