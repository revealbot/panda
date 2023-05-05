# frozen_string_literal: true

module Panda
  class APIError < StandardError
    attr_reader :body,
                :http_status,
                :code,
                :message,
                :request_id

    def initialize(http_status, body)
      @http_status = http_status
      @body = body

      super(parse_error)
    end

    private

    def parse_error
      return if body.empty?

      @code = body.fetch('code', http_status)
      @message = body.fetch('message', body)
      @request_id = body.fetch('request_id', 'unknown')

      "Request #{@request_id}; #{@code}: #{message}"
    end
  end

  class NoPermissionsError < APIError; end

  class NotAuthorizedError < APIError; end

  class TooManyRequestsError < APIError; end
end
