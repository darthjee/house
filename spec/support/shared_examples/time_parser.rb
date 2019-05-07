# frozen_string_literal: true

shared_examples 'a method that knows how to parse time' do |method, tests|
  tests.each do |string, expected|
    it "parses '#{string}' into #{expected} seconds" do
      expect(subject.public_send(method, string)).to eq(expected)
    end
  end
end
