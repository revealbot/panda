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
      # check that status is 200
      raise Panda::APIError.new(status, body) if status != 200

      @parsed_body = JSON.parse(body)
      @request_id = parsed_body['request_id']
      return if parsed_body['code'] == SUCCESS_CODE

      raise Panda::APIError.new(status, body)
    end
  end
end
