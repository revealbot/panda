# frozen_string_literal: true

module Panda
  class Item
    def initialize(response)
      response.parsed_body.fetch('data', {})
    end
  end
end
