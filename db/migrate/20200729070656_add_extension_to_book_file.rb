class AddExtensionToBookFile < ActiveRecord::Migration[5.2]
  def change
    add_column :book_files, :extension, :string
  end
end
