# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class Label < Banzai::Filter
          def call(input)
            input.gsub(/\[(GET|POST|PUT|DELETE|OPTIONS)\]/i) do |_s|
              "<span class='Vlt-badge #{class_name(Regexp.last_match(1))}'>#{Regexp.last_match(1)}</span> "
            end
          end

          private

          def class_name(text)
            case text
            when 'POST'
              'Vlt-badge--green'
            when 'GET'
              'Vlt-badge--blue'
            when 'DELETE'
              'Vlt-badge--red'
            when 'PUT'
              'Vlt-badge--yellow'
            when 'OPTIONS'
              'Vlt-badge--grey'
            end
          end
        end
      end
    end
  end
end
