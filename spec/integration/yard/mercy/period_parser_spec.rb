# frozen_string_literal: true

require 'spec_helper'

describe Mercy::PeriodParser do
  describe 'yard' do
    describe '.parse' do
      it 'parses string to period' do
        expect(described_class.parse('3days')).to eq(3.days)
      end
    end

    describe '#to_seconds' do
      subject(:parser) { described_class.new('30minutes') }

      it 'parses to period' do
        expect(parser.to_seconds).to eq(30.minutes)
      end
    end
  end
end
