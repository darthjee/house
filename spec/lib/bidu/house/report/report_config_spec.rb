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
  end
end