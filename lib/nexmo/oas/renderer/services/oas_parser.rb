# frozen_string_literal: true

require 'oas_parser'

module OasParser
  class Path
    def servers
      raw['servers']
    end
  end

  class Endpoint
    def oauth?
      return false unless security

      security_schemes.any?(&:oauth?)
    end

    def bearer?
      return false unless security

      security_schemes.any?(&:bearer?)
    end

    def basic_auth?
      return false unless security

      security_schemes.any?(&:basic_auth?)
    end

    def jwt?
      return false unless security

      security_schemes.any?(&:jwt?)
    end

    alias original_security_schemes security_schemes

    def security_schemes
      security_schemes = security.flat_map(&:keys)

      security_schemes += definition.security.flat_map(&:keys) if definition

      security_schemes = security_schemes.uniq

      security_schemes.map do |security_scheme_name|
        parameters =
          definition.components['securitySchemes'][security_scheme_name]
        SecurityScheme.new(security_scheme_name, parameters)
      end
    end

    def security_schema_parameters
      raw_security_schema_parameters = original_security_schemes.select do |security_schema|
        security_schema['in'].present? && security_schema['in'].present?
      end

      security_schema_parameter_defaults = {
        'type' => 'string',
        'example' => 'abc123',
        'default' => false
      }

      raw_security_schema_parameters.map do |definition|
        definition = security_schema_parameter_defaults.merge(definition)
        OasParser::Parameter.new(self, definition)
      end
    end
  end

  class SecurityScheme
    attr_accessor(
      :type,
      :description,
      :name,
      :in,
      :scheme,
      :bearer_format,
      :open_id_connect_url
    )

    def initialize(name, parameters)
      @type = parameters['type']
      @description = parameters['description']
      @name = name
      @in = parameters['in']
      @scheme = parameters['scheme']
      @bearer_format = parameters['bearerFormat']
      @openIdConnectUrl = parameters['openIdConnectUrl']
    end

    def bearer?
      scheme == 'bearer'
    end

    def basic_auth?
      scheme == 'basic_auth'
    end

    def oauth?
      scheme == 'oauth2' || (bearer? && bearer_format == 'OAuth')
    end

    def jwt?
      bearer? && bearer_format == 'JWT'
    end
  end
end
