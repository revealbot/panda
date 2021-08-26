# frozen_string_literal: true

module Panda
  class Collection < Array
    # panda client that was used to retrieve this collection
    attr_reader :client

    # current page
    attr_reader :page,
      :page_size,
      :total_number,
      :total_page

    def initialize(response, client)
      @response = response
      @client = client

      @page = response.parsed_body.dig('data', 'page_info', 'page')
      @page_size = response.parsed_body.dig('data', 'page_info', 'page_size')
      @total_number = response.parsed_body.dig('data', 'page_info', 'total_number')
      @total_page = response.parsed_body.dig('data', 'page_info', 'total_page')

      super response.parsed_body.dig('data', 'list')
    end
  end
end
