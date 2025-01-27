# frozen_string_literal: true

require 'spec_helper'

describe Panda::Item do
  let(:response) { Panda::HTTPResponse.new(200, {}, response_body) }

  context 'when item is token info' do
    let(:response_body) do
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

  context 'item is user info' do
    let(:response_body) do
      {
        'message' => 'OK',
        'code' => 0,
        'data' => {
          'display_name' => 'user_name',
          'email' => 'user.email@example.com',
          'core_user_id' => 'core_user_id',
          'avatar_url' => 'https://example.com/avatar.jpg'
        },
        'request_id': '2020031009181201018904922342087A16'
      }
    end

    it 'gets user info' do
      user_info = described_class.new(response)

      expect(user_info['display_name']).to eq('user_name')
      expect(user_info['email']).to eq('user.email@example.com')
    end
  end
end
