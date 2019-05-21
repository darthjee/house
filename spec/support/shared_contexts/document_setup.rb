RSpec.shared_context 'documents setup' do
  let(:a_successes)     { 0 }
  let(:b_successes)     { 0 }
  let(:c_successes)     { 0 }
  let(:a_errors)        { 0 }
  let(:b_errors)        { 0 }
  let(:c_errors)        { 0 }

  let(:setup) do
    {
      success: { a: a_successes, b: b_successes, c: c_successes },
      error: { a: a_errors, b: b_errors, c: c_errors },
    }
  end

  before do
    Document.delete_all

    setup.each do |status, map|
      map.each do |doc_type, quantity|
        quantity.times do
          Document.create(
            status: status, doc_type: doc_type, external_id: Document.count
          )
        end
      end
    end
  end
end
