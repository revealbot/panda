# frozen_string_literal: true

require 'spec_helper'

describe Panda::HTTPRequest do
  before do
    Panda.config.api_version = 'v1.2'
  end

  it 'adds api version to url' do
    request = described_class.new('GET', 'oauth2/advertiser/get/')

    expect(request.url).to eq('https://ads.tiktok.com/open_api/v1.2/oauth2/advertiser/get/')
  end

  it 'converts GET array params to JSON string' do
    request = described_class.new(
      'GET',
      'advertiser/info/',
      {
        fields: %w[id name status timezone],
        advertiser_ids: [3456321, 3346421]
      }
    )

    expect(request.params).to eq(
      {
        fields: '["id","name","status","timezone"]',
        advertiser_ids: '[3456321,3346421]'
      }
    )
  end

  it 'adds additional headers' do
    request = described_class.new('GET', 'oauth2/advertiser/get', {}, { 'Access-Token' => 'sometoken' })

    expect(request.headers).to eq(
      {
        'Access-Token' => 'sometoken',
        'Accept' => 'application/json',
        'User-Agent' => "ruby-panda-tiktok/#{Panda::VERSION}"
      }
    )
  end
end
