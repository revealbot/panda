# frozen_string_literal: true

module Panda
  class HTTPResponse
    SUCCESS_CODE = 0

    attr_reader :status, :headers, :parsed_body, :request_id

    def initialize(status, headers, body)
      @status = status
      @headers = headers

      parse(body)
    end

    private

    def parse(body)
      @parsed_body = JSON.parse(body)
      @request_id = parsed_body['request_id']
      return if parsed_body['code'] == SUCCESS_CODE
    end
  end
end
