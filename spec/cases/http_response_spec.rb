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

  it 'raises error in case of error API response' do
    expect do
      described_class.new(200, {}, {
        message: 'PERMISSION_ERROR',
        code: 40002,
        request_id: request_id
      }.to_json)
    end.to raise_error(
      an_instance_of(Panda::APIError).and(
        having_attributes(code: 40002, message: 'PERMISSION_ERROR', request_id: request_id)
      )
    )
  end
end
