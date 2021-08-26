# frozen_string_literal: true

module Panda
  class APIError < StandardError
    attr_reader :body,
      :http_status,
      :code,
      :message

    def initialize(http_status, body)
      @http_status = http_status
      @body = body

      super(parse_error)
    end

    private

    def parse_error
      return unless body.present?

      parsed_body = begin
        JSON.parse(body)
      rescue JSON::ParserError
        {}
      end
      @code = parsed_body.fetch('code', http_status)
      @message = parsed_body.fetch('message', body)

      "#{@code}: #{message}"
    end
  end
end
