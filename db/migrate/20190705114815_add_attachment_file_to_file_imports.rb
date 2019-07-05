class AddAttachmentFileToFileImports < ActiveRecord::Migration[5.1]
  def self.up
    change_table :file_imports do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :file_imports, :file
  end
end
