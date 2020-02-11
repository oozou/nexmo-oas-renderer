# frozen_string_literal: true

require_relative '../models/tutorial'
require 'banzai'
require 'yaml'

module Nexmo
  module OAS
    module Renderer
      module Filters
        class Tutorials < Banzai::Filter
          def call(input)
            input.gsub(/```tutorials(.+?)```/m) do |_s|
              config = YAML.safe_load(Regexp.last_match(1))
              @product = config['product']
              @tutorials = Models::Tutorial.by_product(@product)

              # Default to plain layout, but allow people to override it
              config['layout'] = 'list/plain' unless config['layout']

              erb = File.read("#{API.root}/views/tutorials/#{config['layout']}.html.erb")
              html = ERB.new(erb).result(binding)
              "FREEZESTART#{Base64.urlsafe_encode64(html)}FREEZEEND"
            end
          end
        end
      end
    end
  end
end
