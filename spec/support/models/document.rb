# frozen_string_literal: true

class Document < ActiveRecord::Base
  scope :with_error,   -> { where(status: :error) }
  scope :with_success, -> { where(status: :success) }
  scope :type_a,       -> { where(doc_type: :a) }
  scope :type_b,       -> { where(doc_type: :b) }
end
