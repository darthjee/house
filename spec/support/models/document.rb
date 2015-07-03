class Document < ActiveRecord::Base
  scope :with_error, proc { where(status: :error) }
end