# frozen_string_literal: true

require 'json'

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
  end
end
