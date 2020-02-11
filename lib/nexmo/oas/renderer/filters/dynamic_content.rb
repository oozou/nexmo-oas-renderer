# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class DynamicContent < Banzai::Filter
          def call(input)
            input.gsub(/(\s|^)\[\~(.+?)\~\](\s|$)/) do
              content = environment_value(Regexp.last_match(2)) || config_value(Regexp.last_match(2)) || "VALUE NOT SET: #{Regexp.last_match(2)}"
              "#{Regexp.last_match(1)}#{content}#{Regexp.last_match(3)}"
            end
          end

          private

          def environment_value(key)
            return nil unless ENV['DYNAMIC_CONTENT']

            @environment_dynamic_content ||= YAML.safe_load(ENV['DYNAMIC_CONTENT'])
            @environment_dynamic_content ||= YAML.safe_load(temp)
            @environment_dynamic_content[key]
          end

          def config_value(key)
            @config_dynamic_content ||= YAML.load_file("#{API.root}/config/dynamic_content.yml")
            @config_dynamic_content[key]
          end
        end
      end
    end
  end
end
