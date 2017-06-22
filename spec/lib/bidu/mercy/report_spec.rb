require 'spec_helper'

describe Bidu::Mercy::Report do
  class Bidu::Mercy::Report::Dummy1 < Bidu::Mercy::Report
    DEFAULT_OPTION = {
      option_value: 1,
      other_option: 10
    }
    json_parse :option_value, :other_option, case: :snake
  end
  class Bidu::Mercy::Report::Dummy2 < Bidu::Mercy::Report::Dummy1; end
  class Bidu::Mercy::Report::Dummy3 < Bidu::Mercy::Report::Dummy1
    DEFAULT_OPTION = { option_value: 5 }
  end

  describe 'default_options' do
    let(:report_class) { described_class::Dummy1 }
    let(:subject) { report_class.new }
    
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

