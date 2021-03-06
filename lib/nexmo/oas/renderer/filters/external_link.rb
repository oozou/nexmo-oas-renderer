# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class ExternalLink < Banzai::Filter
          def call(input)
            @input = input

            document.css('a').each_with_index do |link, _index|
              unless link['href']&.start_with?('http') && link['class'] && !link['class'].include?('no-external-marker')
                next
              end

              link['target'] = '_blank'
              next unless link.css('svg').empty?

              link.add_child <<~HEREDOC
                &nbsp;<svg class="Vlt-icon Vlt-icon--smaller Vlt-icon--text-bottom Vlt-blue-dark"><use xlink:href="/assets/symbol/volta-icons.svg#Vlt-icon-open"></use></svg>
              HEREDOC
            end

            @document.to_html
          end

          private

          def document
            @document ||= Nokogiri::HTML::DocumentFragment.parse(@input)
          end
        end
      end
    end
  end
end
