# frozen_string_literal: true

require 'spec_helper'

describe Panda::Configuration do
  subject { described_class.new }

  it 'sets default API base url' do
    expect(subject.api_base_url).to eq(described_class::API_BASE_URL)
  end
end
