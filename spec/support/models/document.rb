class Document < ActiveRecord::Base
  scope :with_error, proc { where(status: :error) }
  scope :with_success, proc { where(status: :success) }
  scope :type_a, proc { where(doc_type: :a) }
  scope :type_b, proc { where(doc_type: :b) }
end
