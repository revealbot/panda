# frozen_string_literal: true

module Panda
  class Item
    attr_reader :data

    def initialize(response)
      @data = response.parsed_body.fetch('data', {})
    end

    def [](key)
      data[key]
    end
  end
end
