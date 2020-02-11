# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class Screenshot < Banzai::Filter
          def call(input)
            input.gsub(/```screenshot(.+?)```/m) do |_s|
              config = YAML.safe_load(Regexp.last_match(1))
              if config['image'] && File.file?(config['image'])
                "![Screenshot](#{config['image'].gsub('public', '')})"
              else
                <<~HEREDOC
                  ## Missing image
                  To fix this run:
                  ```
                  $ rake screenshots:update
                  ```
                HEREDOC
              end
            end
          end
        end
      end
    end
  end
end
