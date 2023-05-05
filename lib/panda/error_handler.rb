# frozen_string_literal: true

require 'faraday'
module FaradayMiddleware
  class PandaErrorHandler < Faraday::Middleware
    def on_complete(env)
      raise Panda::APIError.new(env.status, env.body) if env[:status] != 200

      parsed_body = JSON.parse(env.body)
      raise_error(parsed_body, env.status, env.body)
    end

    private

    def raise_error(parsed_body, status, body)
      case parsed_body['code']
      when 40001
        raise ::Panda::NoPermissionsError.new(status, body)
      when 40105
        raise ::Panda::NotAuthorizedError.new(status, body)
      when 40100
        raise ::Panda::TooManyRequestsError.new(status, body)
      when 40000..60000
        raise ::Panda::APIError.new(status, body)
      end
    end
  end
end
