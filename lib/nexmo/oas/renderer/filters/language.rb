# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class Language < Banzai::Filter
          def call(input)
            input.gsub(/\[(.+?)\]\(lang:.+?(?:'(.+?)'|"(.+?)")\)/) do |_s|
              "<span lang='#{Regexp.last_match(2)}'>#{Regexp.last_match(1)}</span>"
            end
          end
        end
      end
    end
  end
end
