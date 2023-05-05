# frozen_string_literal: true

require 'spec_helper'

describe Panda::HTTPResponse do
  let(:request_id) { SecureRandom.hex }

  it 'parses json body from response' do
    response = described_class.new(200, {}, {
      message: 'OK',
      code: 0,
      data: { list: [] },
      request_id: request_id
    }.to_json)

    expect(response.request_id).to eq(request_id)
    expect(response.parsed_body).to eq(
      {
        'message' => 'OK',
        'code' => 0,
        'data' => { 'list' => [] },
        'request_id' => request_id
      }
    )
  end
end
