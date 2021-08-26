# frozen_string_literal: true

module Panda
  class Configuration
    API_BASE_URL = 'https://ads.tiktok.com/'

    attr_accessor :app_id,
      :app_secret,
      :api_version,
      :api_base_url

    def initialize
      @api_base_url = API_BASE_URL
    end
  end
end
