# frozen_string_literal: true

require 'spec_helper'

describe Panda::ErrorMiddleware do
  let(:body) do
    {
      'message' => 'OK',
      'code' => 0,
      'data' => {},
      'response_id' => '2023050409181201018904922342087A16'
    }
  end
  let(:status) { 200 }
  let(:env) do
    e = Faraday::Env.new
    e.status = status
    e.body = body
    e
  end

  it 'when response hasn\'t error' do
    expect { described_class.new.on_complete(env) }.not_to raise_error
  end

  context 'when response raise error' do
    let(:body) do
      {
        'message' => 'ERROR',
        'code' => code,
        'response_id' => '2020031009181201018904922342087A16'
      }
    end

    context 'when response raises NotAuthorizedError' do
      let(:code) { 40105 }

      it 'throws error' do
        expect { described_class.new.on_complete(env) }.to raise_error(Panda::NotAuthorizedError)
      end
    end

    context 'when response raises TooManyRequestsError' do
      let(:code) { 40100 }

      it 'throws error' do
        expect { described_class.new.on_complete(env) }.to raise_error(Panda::TooManyRequestsError)
      end
    end

    context 'when response raises NoPermissionsError' do
      let(:code) { 40001 }

      it 'throws error' do
        expect { described_class.new.on_complete(env) }.to raise_error(Panda::NoPermissionsError)
      end
    end

    context 'when response raises APIError' do
      let(:code) { 40000 }

      it 'throws error' do
        expect { described_class.new.on_complete(env) }.to raise_error(Panda::APIError)
      end
    end
  end
end
