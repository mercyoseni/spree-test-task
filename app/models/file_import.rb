class FileImport < ApplicationRecord
  serialize :error, Array

  has_attached_file :file

  validates_attachment :file, presence: true,
    content_type: { content_type: 'text/csv' }

  before_post_process :set_content_type

  private

  def set_content_type
    mime_type = MIME::Types.type_for(file_file_name).first.to_s
    file.instance_write(:content_type, mime_type)
  end
end
