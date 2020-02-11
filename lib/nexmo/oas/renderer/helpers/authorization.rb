require_relative '../lib/protected_action'

module Nexmo
  module OAS
    module Renderer
      module Helpers
        module Authorization
          def protect!(credentials={})
            return if authorized?

            guard = ::Nexmo::OAS::Renderer::ProtectedAction.new(
              self, credentials
            )
            guard.check!
            request.env['REMOTE_USER'] = guard.remote_user
          end

          def authorized?
            request.env['REMOTE_USER']
          end
        end
      end
    end
  end
end
