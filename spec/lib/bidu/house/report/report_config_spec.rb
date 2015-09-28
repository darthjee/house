require 'spec_helper'

describe Bidu::House::ReportConfig do
  let(:config) { {} }
  let(:parameters) { {} }
  let(:subject) { described_class.new(config) }

  describe '#build' do
    context 'when no config is given' do
      it do
        expect(subject.build(parameters)).to be_a(Bidu::House::Report::Error)
      end
    end

    context 'when a dummy type is given' do
      let(:config) { { type: :dummy } }

      it do
        expect(subject.build(parameters)).to be_a(Bidu::House::Report::Dummy)
      end
    end

    context 'when a class is given as type' do
      let(:config) { { type: Bidu::House::Report::Dummy } }

      it do
        expect(subject.build(parameters)).to be_a(Bidu::House::Report::Error)
      end
    end
  end
end