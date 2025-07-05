# frozen_string_literal: true

require 'spec_helper'
require 'oh_snap/rspec'

RSpec.configure do |config|
  config.include OhSnap::RSpec
end

RSpec.describe 'OhSnap::RSpec' do
  describe '#snapshot' do
    it 'asserts equality with named snapshot', focus: true do
      expect(snapshot(name: 'named_snapshot')).to eq('expected value')
    end

    it 'asserts equality with default snapshot' do
      expect(snapshot).to eq('expected value')
    end

    it 'refutes equality in inverted comparison' do
      expect('expected value').not_to eq(snapshot)
    end
  end
end
