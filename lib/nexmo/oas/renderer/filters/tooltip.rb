# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class Tooltip < Banzai::Filter
          def call(input)
            input.gsub(/\^\[([a-zA-Z0-9\s:\-]+)\]\((.+?)\)/) do
              tooltip = <<~HEREDOC
                <span class="Vlt-tooltip Vlt-tooltip--top" title="#{Regexp.last_match(2)}" tabindex="0">
                  #{Regexp.last_match(1)}&nbsp;
                  <svg class="Vlt-icon Vlt-icon--smaller Vlt-icon--text-bottom Vlt-blue" aria-hidden="true"><use xlink:href="/assets/symbol/volta-icons.svg#Vlt-icon-help-negative"/></svg>
                </span>
              HEREDOC

              "FREEZESTART#{Base64.urlsafe_encode64(tooltip)}FREEZEEND"
            end
          end
        end
      end
    end
  end
end
