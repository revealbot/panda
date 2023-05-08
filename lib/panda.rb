# frozen_string_literal: true

require 'json'
require 'faraday'

require 'panda/client'
require 'panda/configuration'

module Panda
  # Ruby client for TikTok Ads API

  class << self
    def configure
      yield config
    end

    def config
      @config ||= Panda::Configuration.new
    end

    def make_get_request(request)
      connection = Faraday.new do |conn|
        conn.use      Panda::ErrorMiddleware
        conn.request  :json
        conn.response :json
      end

      response = connection.get(request.url, request.params, request.headers)
      Panda::HTTPResponse.new(response.status, response.headers, response.body)
    end
  end
end
