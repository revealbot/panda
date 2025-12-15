# frozen_string_literal: true

require 'panda/collection'
require 'panda/error_middleware'
require 'panda/errors'
require 'panda/http_request'
require 'panda/http_response'
require 'panda/item'

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
        params: {
          access_token: access_token,
          app_id: Panda.config.app_id,
          secret: Panda.config.app_secret
        }
      )
    end

    def advertiser_info(ids, params = {})
      get_collection('advertiser/info/', params: params.merge(advertiser_ids: ids))
    end

    # returns a list of campaigngs for an advertizer
    def campaigns(advertizer_id, params = {})
      get_collection('campaign/get/', params: params.merge(advertiser_id: advertizer_id))
    end

    def ad_groups(advertizer_id, params = {})
      get_collection('adgroup/get/', params: params.merge(advertiser_id: advertizer_id))
    end

    def ads(advertizer_id, params = {})
      get_collection('ad/get/', params: params.merge(advertiser_id: advertizer_id))
    end

    def report(advertiser_id, report_type, dimensions, params = {})
      get_collection(
        'report/integrated/get/',
        params: params.merge(advertiser_id: advertiser_id, report_type: report_type, dimensions: dimensions)
      )
    end

    def user_info
      get_user('user/info/')
    end

    # requires token from Accounts API
    def token_info
      get_token(
        'tt_user/token_info/get/',
        app_id: Panda.config.app_id,
        access_token: access_token
      )
    end

    # list of apps for an advertiser
    def app_list(advertiser_id)
      get_collection('app/list/', params: { advertiser_id: advertiser_id }, collection_key: 'apps')
    end

    private

    def get_user(path, params = {})
      request = Panda::HTTPRequest.new('GET', path, params, 'Access-Token' => access_token)
      Panda::Item.new(Panda.make_request(request))
    end

    def get_token(path, params = {})
      request = Panda::HTTPRequest.new('POST', path, params)
      Panda::Item.new(Panda.make_request(request))
    end

    def get_collection(path, params: {}, collection_key: 'list')
      request = Panda::HTTPRequest.new('GET', path, params, 'Access-Token' => access_token)
      Panda::Collection.new(Panda.make_request(request), self, collection_key)
    end
  end
end
