# frozen_string_literal: true

require 'spec_helper'

describe Panda::UserInfo do
  let(:response) { Panda::HTTPResponse.new(200, {}, user_response_body) }

  context 'response with result list field in data field' do
    let(:user_response_body) do
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
