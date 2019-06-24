class FileImport < ApplicationRecord
  serialize :error, Array

  validates_presence_of :filename
end
