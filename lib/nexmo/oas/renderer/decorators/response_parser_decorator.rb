# frozen_string_literal: true

require 'rouge'
require 'neatjson'
require_relative '../services/oas_parser'

module Nexmo
  module OAS
    module Renderer
      class ResponseParserDecorator < ::OasParser::ResponseParser
        def formatted_json
          JSON.neat_generate(parse,
                             wrap: true,
                             after_colon: 1)
        end

        def formatted_xml(xml_options = {})
          xml_options[:root] = xml_options['name'] if xml_options
          xml_string = xml(xml_options)
          xml_string.gsub!(%r{^(\s+?)(<(?:\w|\=|\"|\_|\s)+?\>)(.+?)(</.+?>)}).each do |s|
            indentation = Regexp.last_match(1)
            indentation_plus_one = "#{Regexp.last_match(1)}  "
            opening_tag = Regexp.last_match(2)
            content = Regexp.last_match(3)
            closing_tag = Regexp.last_match(4)

            next(s) if (indentation.size + opening_tag.size + content.size) < 60

            next "#{indentation}#{opening_tag}\n#{indentation_plus_one}#{content}\n#{indentation}#{closing_tag}"
          end

          xml_string
        end

        def html(format = 'application/json', xml_options: nil)
          formatter = Rouge::Formatters::HTML.new

          case format
          when 'application/json', 'application/vnd.api+json'
            lexer = Rouge::Lexer.find('json')
            highlighted_response = formatter.format(lexer.lex(formatted_json))
          when 'text/xml', 'application/xml'
            lexer = Rouge::Lexer.find('xml')
            highlighted_response = formatter.format(lexer.lex(formatted_xml(xml_options)))
          end

          output = <<~HEREDOC
            <span class="Vlt-badge Vlt-badge">#{format}</span>
            <pre class="highlight json"><code>#{highlighted_response}</code></pre>
          HEREDOC

          output
        end
      end
    end
  end
end
