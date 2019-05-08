# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :documents, force: true do |t|
    t.string :status
    t.string :doc_type
    t.integer :external_id
    t.integer :outter_external_id
    t.timestamps null: true
  end
end
