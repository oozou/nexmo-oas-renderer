# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class Anchor < Banzai::Filter
          def call(input)
            input.gsub(/^[\u{2693}](.+?)\n/) do
              <<~HEREDOC
                <a name="#{Regexp.last_match(1).parameterize}"></a>
              HEREDOC
            end
          end
        end
      end
    end
  end
end
