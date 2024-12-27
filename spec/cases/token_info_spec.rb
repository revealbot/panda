# frozen_string_literal: true

require 'spec_helper'

describe Panda::TokenInfo do
  let(:response) { Panda::HTTPResponse.new(200, {}, token_response_body) }

  context 'response with result list field in data field' do
    let(:token_response_body) do
      {
        'message' => 'OK',
        'code' => 0,
        'data' => {
          'app_id' => Panda.config.app_id,
          'creator_id' => 'test_creator_id',
          'scope' => 'user.info.basic'
        },
        'request_id': '2020031009181201018904922342087A16'
      }
    end

    it 'gets token info' do
      token_info = described_class.new(response)

      expect(token_info['creator_id']).to eq('test_creator_id')
      expect(token_info['scope']).to eq('user.info.basic')
    end
  end
end
