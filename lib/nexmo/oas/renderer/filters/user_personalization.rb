# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class UserPersonalization < Banzai::Filter
          def call(input)
            return input unless options[:current_user]
            return input if options[:current_user].api_key.blank?
            return input if options[:current_user].api_secret.blank?

            @input = input
            document.css('pre code').each do |code|
              html = code.to_s

              html.gsub!(/(['|"])?NEXMO_API_(KEY|SECRET)['|"]?/) do
                quote = Regexp.last_match(1) || "'"
                value = (
                  case Regexp.last_match(2)
                  when 'KEY' then options[:current_user].api_key
                  when 'SECRET' then options[:current_user].api_secret
                end
                )
                "#{quote}#{value}#{quote}"
              end

              html.gsub!('NEXMO_API_SECRET', "'#{options[:current_user].api_secret}'")

              code.replace(html)
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
