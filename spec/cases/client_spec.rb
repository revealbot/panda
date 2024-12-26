# frozen_string_literal: true

require 'spec_helper'

describe Panda::Client do
  let(:app_id) { SecureRandom.hex }
  let(:app_secret) { SecureRandom.hex }
  let(:token) { SecureRandom.hex }

  before do
    Panda.configure do |c|
      c.app_id = app_id
      c.app_secret = app_secret
    end
  end

  subject { described_class.new(token) }

  describe '#advertisers' do
    it 'calls #get_collection' do
      expect(subject).to receive(:get_collection).with(
        'oauth2/advertiser/get/',
        app_id: app_id,
        secret: app_secret,
        access_token: token
      )

      subject.advertisers
    end
  end

  describe '#advertiser_info' do
    let(:ids) { rand(1..5).times.map { SecureRandom.hex } }
    let(:fields) { %w[id name status timezone currency].sample(3) }

    it 'calls #get_collection' do
      expect(subject).to receive(:get_collection).with('advertiser/info/', { advertiser_ids: ids, fields: fields })

      subject.advertiser_info(ids, fields: fields)
    end
  end

  describe '#token_info' do
    it 'calls #get_token' do
      expect(subject)
        .to receive(:get_token)
        .with('tt_user/token_info/get/', { app_id: Panda.config.app_id, access_token: token })

      subject.token_info
    end
  end
end
