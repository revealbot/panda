# frozen_string_literal: true

require 'panda/collection'
require 'panda/error_middleware'
require 'panda/errors'
require 'panda/http_request'
require 'panda/http_response'

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
        'report/integrated/get/',
        params.merge(
          advertiser_id: advertiser_id,
          report_type: report_type,
          dimensions: dimensions
        )
      )
    end

    def token_info
      get_token(
        'tt_user/token_info/get/',
        app_id: Panda.config.app_id,
        access_token: access_token,
      )
    end

    private

    def get_token(path, params = {})
      request = Panda::HTTPRequest.new('GET', path, params)
      Panda::Item.new(Panda.make_get_request(request))
    end

    def get_collection(path, params = {})
      request = Panda::HTTPRequest.new('GET', path, params, 'Access-Token' => access_token)
      Panda::Collection.new(Panda.make_get_request(request), self)
    end
  end
end
