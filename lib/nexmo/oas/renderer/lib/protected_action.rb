# frozen_string_literal: true

# USAGE
#
# get '/' do
#   protect! :username => 'admin', :password => 'sekret'
#   "This is protected by basic auth"
# end
module Nexmo
  module OAS
    module Renderer
      class ProtectedAction
        attr_reader :credentials, :context

        def initialize(context, credentials = {})
          @credentials = credentials
          @context = context
        end

        def check!
          unauthorized! unless auth.provided?
          bad_request! unless auth.basic?
          unauthorized! unless authorize(*auth.credentials)
        end

        def remote_user
          auth.username
        end

        private

        def authorize(username, password)
          (credentials[:username] == username) && (credentials[:password] == password)
        end

        def unauthorized!
          context.headers['WWW-Authenticate'] =
            %(Basic realm="#{credentials[:realm]}")
          throw :halt, [401, 'Authorization Required']
        end

        def bad_request!
          throw :halt, [400, 'Bad Request']
        end

        def auth
          @auth ||= Rack::Auth::Basic::Request.new(context.request.env)
        end
      end
    end
  end
end
