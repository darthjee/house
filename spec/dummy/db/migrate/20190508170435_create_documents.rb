# frozen_string_literal: true

class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :status
      t.string :doc_type
      t.integer :external_id
      t.integer :outter_external_id
      t.timestamps null: true
    end
  end
end
