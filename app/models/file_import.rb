class FileImport < ApplicationRecord
  serialize :error, Array

  has_attached_file :file
  validates_attachment :file, presence: true
  validates_attachment_content_type :file, content_type: ['text/csv', 'text/plain']
end
