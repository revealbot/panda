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

      data = response.parsed_body.fetch('data', {})
      @page = data.dig('page_info', 'page')
      @page_size = data.dig('page_info', 'page_size')
      @total_number = data.dig('page_info', 'total_number')
      @total_page = data.dig('page_info', 'total_page')

      # some API return result list in data field instead of list field
      super(data.has?('list') ? data['list'] : data)
    end
  end
end
