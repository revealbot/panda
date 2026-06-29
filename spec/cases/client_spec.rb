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
        params: {
          app_id: app_id,
          secret: app_secret,
          access_token: token
        }
      )

      subject.advertisers
    end
  end

  describe '#advertiser_info' do
    let(:ids) { rand(1..5).times.map { SecureRandom.hex } }
    let(:fields) { %w[id name status timezone currency].sample(3) }

    it 'calls #get_collection' do
      expect(subject).to receive(:get_collection).with(
        'advertiser/info/',
        params: { advertiser_ids: ids, fields: fields }
      )

      subject.advertiser_info(ids, fields: fields)
    end
  end

  describe '#user_info' do
    it 'calls #get_user' do
      expect(subject).to receive(:get_user).with('user/info/')

      subject.user_info
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

  describe '#app_list' do
    let(:advertiser_id) { SecureRandom.hex }

    it 'calls #get_collection' do
      expect(subject)
        .to receive(:get_collection)
        .with('app/list/', params: { advertiser_id: advertiser_id }, collection_key: 'apps')

      subject.app_list(advertiser_id)
    end
  end

  describe '#smart_plus_ad_groups' do
    let(:advertiser_id) { SecureRandom.hex }
    let(:filtering) { { adgroup_ids: [SecureRandom.hex] } }

    it 'calls #get_collection with merged params' do
      expect(subject)
        .to receive(:get_collection)
        .with('smart_plus/adgroup/get/', params: { advertiser_id: advertiser_id, filtering: filtering })

      subject.smart_plus_ad_groups(advertiser_id, filtering: filtering)
    end

    it 'calls #get_collection with only advertiser_id when no extra params' do
      expect(subject)
        .to receive(:get_collection)
        .with('smart_plus/adgroup/get/', params: { advertiser_id: advertiser_id })

      subject.smart_plus_ad_groups(advertiser_id)
    end
  end

  describe '#smart_plus_ads' do
    let(:advertiser_id) { SecureRandom.hex }
    let(:filtering) { { ad_ids: [SecureRandom.hex] } }

    it 'calls #get_collection with merged params' do
      expect(subject)
        .to receive(:get_collection)
        .with('smart_plus/ad/get/', params: { advertiser_id: advertiser_id, filtering: filtering })

      subject.smart_plus_ads(advertiser_id, filtering: filtering)
    end

    it 'calls #get_collection with only advertiser_id when no extra params' do
      expect(subject)
        .to receive(:get_collection)
        .with('smart_plus/ad/get/', params: { advertiser_id: advertiser_id })

      subject.smart_plus_ads(advertiser_id)
    end
  end

  describe '#get_collection (pagination)' do
    let(:path) { 'campaign/get/' }

    def page_body(page, items)
      {
        'code' => 0,
        'message' => 'OK',
        'data' => {
          'list' => items,
          'page_info' => { 'page' => page, 'page_size' => 2, 'total_number' => 5, 'total_page' => 3 }
        }
      }
    end

    context 'when no page is specified' do
      before do
        responses = {
          1 => Panda::HTTPResponse.new(200, {}, page_body(1, [{ 'id' => '1' }, { 'id' => '2' }])),
          2 => Panda::HTTPResponse.new(200, {}, page_body(2, [{ 'id' => '3' }, { 'id' => '4' }])),
          3 => Panda::HTTPResponse.new(200, {}, page_body(3, [{ 'id' => '5' }]))
        }

        allow(Panda).to receive(:make_request) { |request| responses.fetch(request.raw_params.fetch(:page, 1)) }
      end

      it 'collects items from every page' do
        collection = subject.send(:get_collection, path)

        expect(collection.map { |item| item['id'] }).to eq(%w[1 2 3 4 5])
      end

      it 'requests each page exactly once' do
        subject.send(:get_collection, path)

        expect(Panda).to have_received(:make_request).exactly(3).times
      end
    end

    context 'when a specific page is specified' do
      before do
        allow(Panda)
          .to receive(:make_request)
          .and_return(Panda::HTTPResponse.new(200, {}, page_body(2, [{ 'id' => '3' }, { 'id' => '4' }])))
      end

      it 'returns only the requested page' do
        collection = subject.send(:get_collection, path, params: { page: 2 })

        expect(collection.map { |item| item['id'] }).to eq(%w[3 4])
      end

      it 'makes a single request' do
        subject.send(:get_collection, path, params: { page: 2 })

        expect(Panda).to have_received(:make_request).once
      end
    end

    context 'when the response has no page info' do
      before do
        body = { 'code' => 0, 'message' => 'OK', 'data' => [{ 'id' => '1' }] }
        allow(Panda).to receive(:make_request).and_return(Panda::HTTPResponse.new(200, {}, body))
      end

      it 'returns the single collection without extra requests' do
        collection = subject.send(:get_collection, path)

        expect(collection.map { |item| item['id'] }).to eq(%w[1])
        expect(Panda).to have_received(:make_request).once
      end
    end
  end
end
