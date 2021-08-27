# frozen_string_literal: true

require 'panda/version'

module Panda
  class HTTPRequest
    attr_reader :raw_method, :raw_path, :raw_params, :raw_headers

    def initialize(method, path, params = {}, headers = {})
      @raw_method = method
      @raw_path = path
      @raw_params = params
      @raw_headers = headers
    end

    def method
      raw_method
    end

    def url
      uri = URI.parse(Panda.config.api_base_url)
      uri.path = "/open_api/#{Panda.config.api_version}/#{raw_path}"
      uri.to_s
    end

    # TikTok accepts arrays in GET request only as json strings
    def params
      return raw_params unless get_request? && raw_params.is_a?(Hash)

      raw_params.inject({}) do |hash, (key, value)|
        hash.merge(key => value.is_a?(Array) ? value.to_json : value)
      end
    end

    def headers
      raw_headers.merge(
        'Accept' => 'application/json',
        'User-Agent' => "ruby-panda-tiktok/#{Panda::VERSION}"
      )
    end

    private

    # rubocop:disable Naming/AccessorMethodName
    def get_request?
      method == 'GET'
    end
    # rubocop:enable Naming/AccessorMethodName
  end
end
