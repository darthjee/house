class Document < ActiveRecord::Base
  scope :with_error, proc { where(status: :error) }
  scope :with_success, proc { where(status: :success) }
end
