# frozen_string_literal: true

require 'faraday'
module Panda
  class ErrorMiddleware < Faraday::Middleware
    def on_complete(env)
      raise Panda::APIError.new(env.status, env.body) unless env.success?

      check_and_raise!(env.status, env.body)
    end

    private

    def check_and_raise!(status, body)
      case body['code']
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
