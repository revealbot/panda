# frozen_string_literal: true

require 'faraday'

require 'panda/collection'
require 'panda/errors'
require 'panda/response'

module Panda
  class Client
    attr_reader :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    # returns a list of advertisers available for access token
    def advertisers
      get_collection(
        'oauth2/advertiser/get/',
        access_token: access_token,
        app_id: Panda.config.app_id,
        secret: Panda.config.app_secret
      )
    end

    def advertiser_info(ids, params = {})
      get_collection('advertiser/info/', params.merge(advertiser_ids: ids))
    end

    # returns a list of campaigngs for an advertizer
    def campaigns(advertizer_id, params = {})
      get_collection('campaign/get/', params.merge(advertiser_id: advertizer_id))
    end

    def ad_groups(advertizer_id, params = {})
      get_collection('adgroup/get/', params.merge(advertiser_id: advertizer_id))
    end

    def ads(advertizer_id, params = {})
      get_collection('ad/get/', params.merge(advertiser_id: advertizer_id))
    end

    def report(advertiser_id, report_type, dimensions, params = {})
      get_collection(
        'reports/integrated/get/',
        params.merge(
          advertiser_id: advertiser_id,
          report_type: report_type,
          dimensions: dimensions
        )
      )
    end

    def get_collection(path, params = {})
      url = URI.parse(Panda.config.api_base_url)
      url.path = "/open_api/#{Panda.config.api_version}/#{path}"

      response = Faraday.get(url.to_s, params, 'Access-Token' => access_token)
      Panda::Collection.new(
        Panda::Response.new(response.status, response.headers, response.body),
        self
      )
    end
  end
end
