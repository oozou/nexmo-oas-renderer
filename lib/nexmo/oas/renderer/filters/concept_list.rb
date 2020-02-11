# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class ConceptList < Banzai::Filter
          def call(input)
            input.gsub(/```concept_list(.+?)```/m) do |_s|
              config = YAML.safe_load(Regexp.last_match(1))

              raise 'concept_list filter takes a YAML config' if config.nil?
              unless config['product'] || config['concepts']
                raise "concept_list filter requires 'product' or 'concepts' key"
              end

              if config['product']
                @product = config['product']
                @concepts = Concept.by_product(@product)
              elsif config['concepts']
                @concepts = Concept.by_name(config['concepts'])
              end

              @concepts.reject!(&:ignore_in_list)

              return '' if @concepts.empty?

              erb = File.read("#{API.root}/views/concepts/list/plain.html.erb")
              html = ERB.new(erb).result(binding)
              "FREEZESTART#{Base64.urlsafe_encode64(html)}FREEZEEND"
            end
          end
        end
      end
    end
  end
end
