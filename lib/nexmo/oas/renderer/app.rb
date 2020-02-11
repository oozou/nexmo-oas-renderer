require 'sinatra/base'
require 'active_support'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/string/output_safety'
require 'active_model'

require_relative './decorators/response_parser_decorator'
require_relative './pipelines/markdown_pipeline'
require_relative './presenters/api_specification'
require_relative './presenters/open_api_specification'
require_relative './presenters/navigation'
require_relative './presenters/response_tabs'
require_relative './helpers/render'
require_relative './helpers/navigation'
require_relative './helpers/summary'
require_relative './helpers/url'
require_relative './services/code_language_api'
require_relative './lib/core_ext/string'

require 'dotenv/load'

module Nexmo
  module OAS
    module Renderer
      class API < Sinatra::Base

        Tilt.register Tilt::ERBTemplate, 'html.erb'

        view_paths = [views, Rails.root.join("app", "views")]
        set :views, view_paths

        set :mustermann_opts, { type: :rails }
        require 'pry'; binding.pry
        set :oas_path, (
          ENV['OAS_PATH'] ||
            Rails.application.try(:credentials).try(:fetch, :oas_path, './')
        )
        set :bind, '0.0.0.0'

        helpers do
          include Helpers::Render
          include Helpers::Navigation
          include Helpers::Summary
          include Helpers::URL
        end

        def parse_params(extension)
          extensions = extension.split('.')
          case extensions.size
          when 1
            { definition: extensions.first}
          when 2
            if extensions.second.match?(/v\d+/)
              { definition: extensions.first, version: extensions.second }
            else
              { definition: extensions.first, format: extensions.second }
            end
          when 3
            {
              definition: extensions.first,
              version: extensions.second,
              format: extensions.last
            }
          else
            {}
          end
        end

        error Errno::ENOENT do
          layout = :'layouts/api.html'
          not_found erb :'static/404', layout: layout
        end

        error Exception do
          File.read("#{API.root}/public/500.html")
        end

        def set_code_language
          return if params[:code_language] == 'templates'
          @code_language = params[:code_language]
        end

        before do
          set_code_language
        end

        get '(/api)/*definition' do

          parameters = parse_params(params[:definition])
          definition = [
            parameters[:definition], parameters[:version]
          ].compact.join('.')

          @specification = Presenters::OpenApiSpecification.new(
            definition_name: definition,
            expand_responses: params.fetch(:expandResponses, nil),
          )

          erb :'open_api/show', layout: :'layouts/open_api'
        end
      end
    end
  end
end
