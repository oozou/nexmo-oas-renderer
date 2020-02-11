# frozen_string_literal: true

module Nexmo
  module OAS
    module Renderer
      module Filters
        class Modal < Banzai::Filter
          def call(input)
            modals = []

            input.gsub!(/@\[(.+?)\]\((.+?)\)/) do |_s|
              id = 'M' + SecureRandom.hex(12)
              modals << { document: Regexp.last_match(2), id: id }
              "<a href='javascript:void(0)' data-modal='#{id}' class='Vlt-modal-trigger Vlt-text-link'>#{Regexp.last_match(1)}</a>"
            end

            modals = modals.map do |modal|
              filename = modal[:document]
              unless File.exist? filename
                raise "Could not find modal #{filename}"
              end

              document = File.read(filename)
              output = MarkdownPipeline.new.call(document)

              modal = <<~HEREDOC
                <div class="Vlt-modal" id="#{modal[:id]}">
                  <div class="Vlt-modal__panel">
                    <div class="Vlt-modal__content">
                  #{output}
                    </div>
                  </div>
                </div>
              HEREDOC

              "FREEZESTART#{Base64.urlsafe_encode64(modal)}FREEZEEND"
            end

            input + modals.join("\n")
          end
        end
      end
    end
  end
end
