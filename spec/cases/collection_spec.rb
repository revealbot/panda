# frozen_string_literal: true

require 'spec_helper'

describe Panda::Collection do
  let(:response) { Panda::HTTPResponse.new(200, {}, list_response_body) }

  context 'response with result list field in data field' do
    let(:list_response_body) do
      {
        'message' => 'OK',
        'code' => 0,
        'data' => {
          'list' => [
            {
              'id' => 'test_id_1',
              'name' => 'test_name_1'
            },
            {
              'id' => 'test_id_2',
              'name' => 'test_name_2'
            }
          ],
          'page_info' => {
            'page' => 1,
            'page_size' => 2,
            'total_number' => 10,
            'total_page' => 5
          }
        },
        'response_id': '2020031009181201018904922342087A16'
      }
    end

    it 'gets result list' do
      collection = Panda::Collection.new(response, nil)

      expect(collection).to contain_exactly(
        { 'id' => 'test_id_1', 'name' => 'test_name_1' },
        { 'id' => 'test_id_2', 'name' => 'test_name_2' }
      )
      expect(collection.page).to eq(1)
      expect(collection.page_size).to eq(2)
      expect(collection.total_number).to eq(10)
      expect(collection.total_page).to eq(5)
    end
  end

  context 'response with result list inside data field' do
    let(:list_response_body) do
      {
        'message' => 'OK',
        'code' => 0,
        'data' => [
          {
            'id' => 'test_id_1',
            'name' => 'test_name_1'
          },
          {
            'id' => 'test_id_2',
            'name' => 'test_name_2'
          }
        ],
        'response_id': '2020031009181201018904922342087A16'
      }
    end

    it 'gets result list' do
      collection = Panda::Collection.new(response, nil)

      expect(collection).to contain_exactly(
        { 'id' => 'test_id_1', 'name' => 'test_name_1' },
        { 'id' => 'test_id_2', 'name' => 'test_name_2' }
      )
      expect(collection.page).to be_nil
      expect(collection.page_size).to be_nil
      expect(collection.total_number).to be_nil
      expect(collection.total_page).to be_nil
    end
  end
end
