# frozen_string_literal: true

require 'spec_helper'

describe Panda do
  describe '.configure' do
    it 'yields a configurable object' do
      Panda.configure { |c| expect(c).to be_a(Panda::Configuration) }
    end

    it 'caches the config (singleton)' do
      c = Panda.config
      expect(c.object_id).to eq(Panda.config.object_id)
    end
  end

  describe '.config' do
    it 'exposes configured values' do
      Panda.configure { |c| c.app_id = 'test_app_id' }
      expect(Panda.config.app_id).to eq('test_app_id')
    end
  end
end
