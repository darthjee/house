require 'spec_helper'

describe Bidu::Mercy::ReportConfig do
  let(:config) { {} }
  let(:parameters) { {} }
  let(:subject) { described_class.new(config) }

  describe '#build' do
    context 'when no config is given' do
      it do
        expect(subject.build(parameters)).to be_a(Bidu::Mercy::Report::Error)
      end
    end

    context 'when a dummy type is given' do
      let(:config) { { type: :dummy } }

      it do
        expect(subject.build(parameters)).to be_a(Bidu::Mercy::Report::Dummy)
      end
    end

    context 'when a class is given as type' do
      let(:config) { { type: Bidu::Mercy::Report::Dummy } }

      it do
        expect(subject.build(parameters)).to be_a(Bidu::Mercy::Report::Dummy)
      end
    end

    context 'when a global class is given as type' do
      let(:config) { { type: Dummy } }

      it do
        expect(subject.build(parameters)).to be_a(Dummy)
      end
    end
  end
end