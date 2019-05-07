# frozen_string_literal: true

require 'spec_helper'

describe Mercy::Report do
  class Mercy::Report::Dummy1 < Mercy::Report
    DEFAULT_OPTION = {
      option_value: 1,
      other_option: 10
    }.freeze
    expose :option_value, :other_option, case: :snake
  end
  class Mercy::Report::Dummy2 < Mercy::Report::Dummy1; end
  class Mercy::Report::Dummy3 < Mercy::Report::Dummy1
    DEFAULT_OPTION = { option_value: 5 }.freeze
  end

  describe 'default_options' do
    let(:report_class) { described_class::Dummy1 }
    let(:subject)      { report_class.new }

    it 'setup the attributes using class default options' do
      expect(subject.option_value).to eq(1)
      expect(subject.other_option).to eq(10)
    end

    context 'when class inherit options' do
      let(:report_class) { described_class::Dummy2 }

      it 'setup the attributes using superclass default options' do
        expect(subject.option_value).to eq(1)
        expect(subject.other_option).to eq(10)
      end
    end

    context 'when class inherit options but overrides some' do
      let(:report_class) { described_class::Dummy3 }

      it 'setup the attributes using superclass default options' do
        expect(subject.option_value).to eq(5)
        expect(subject.other_option).to eq(10)
      end
    end
  end
end
