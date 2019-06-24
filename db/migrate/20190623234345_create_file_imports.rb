class CreateFileImports < ActiveRecord::Migration[5.1]
  def change
    create_table :file_imports do |t|
      t.string :filename
      t.integer :success_count
      t.text :error
      t.integer :row_count
      t.string :state, default: 'pending'

      t.timestamps
    end
  end
end
