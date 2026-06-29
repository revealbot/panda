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

    # returns a list of Upgraded Smart+ ad groups for an advertiser
    def smart_plus_ad_groups(advertiser_id, params = {})
      get_collection('smart_plus/adgroup/get/', params: params.merge(advertiser_id: advertiser_id))
    end

    # returns a list of Upgraded Smart+ ads for an advertiser
    def smart_plus_ads(advertiser_id, params = {})
      get_collection('smart_plus/ad/get/', params: params.merge(advertiser_id: advertiser_id))
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
      collection = request_collection(path, params, collection_key)

      # honor an explicitly requested page and return it as-is
      return collection if params.key?(:page) || params.key?('page')

      append_remaining_pages(collection, path, params, collection_key)
    end

    def request_collection(path, params, collection_key)
      request = Panda::HTTPRequest.new('GET', path, params, 'Access-Token' => access_token)
      Panda::Collection.new(Panda.make_request(request), self, collection_key)
    end

    # recursively fetches pages 2..total_page and appends their items to the first collection
    def append_remaining_pages(collection, path, params, collection_key, page = 2)
      return collection if collection.total_page.nil? || page > collection.total_page

      next_page = request_collection(path, params.merge(page: page), collection_key)
      collection.concat(next_page)

      append_remaining_pages(collection, path, params, collection_key, page + 1)
    end
  end
end
