# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class PHPInliner < Banzai::Filter
          def call(input)
            input.gsub(/(```php)\n/) do
              "#{Regexp.last_match(1)}?start_inline=1\n"
            end
          end
        end
      end
    end
  end
end
