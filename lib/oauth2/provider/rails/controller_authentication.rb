require 'oauth2/provider'

module OAuth2::Provider::Rails::ControllerAuthentication
  extend ActiveSupport::Concern

  module ClassMethods
    def authenticate_with_oauth(options = {})
      around_action AuthenticationFilter.new(options.delete(:scope)), options
    end

    class AuthenticationFilter
      def initialize(scope = nil)
        @scope = scope
      end

      def around(controller, &block)
        controller.request.env['oauth2'].authenticate_request! :scope => @scope, &block
      end
    end
  end
end