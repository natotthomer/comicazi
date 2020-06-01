class CreateBookFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :book_files do |t|
      t.belongs_to :book
      t.timestamps
    end
  end
end
