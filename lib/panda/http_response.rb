# frozen_string_literal: true

module Panda
  class HTTPResponse
    attr_reader :status, :headers, :parsed_body, :request_id

    def initialize(status, headers, body)
      @status = status
      @headers = headers
      @parsed_body = body
      @request_id = parsed_body['request_id']
    end
  end
end
