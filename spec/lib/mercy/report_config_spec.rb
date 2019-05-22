# frozen_string_literal: true

require 'spec_helper'

describe Mercy::ReportConfig do
  let(:config)     { {} }
  let(:parameters) { {} }
  let(:subject)    { described_class.new(config) }

  describe '#build' do
    context 'when no config is given' do
      it do
        expect(subject.build(parameters)).to be_a(Mercy::Report::Error)
      end
    end

    context 'when a dummy type is given' do
      let(:config) { { type: :dummy } }

      it do
        expect(subject.build(parameters)).to be_a(Mercy::Report::Dummy)
      end
    end

    context 'when a class is given as type' do
      let(:config) { { type: Mercy::Report::Dummy } }

      it do
        expect(subject.build(parameters)).to be_a(Mercy::Report::Dummy)
      end
    end

    context 'when a global class is given as type' do
      let(:config) { { type: DummyReport } }

      it do
        expect(subject.build(parameters)).to be_a(DummyReport)
      end
    end
  end
end
