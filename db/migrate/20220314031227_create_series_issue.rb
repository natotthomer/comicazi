class CreateSeriesIssue < ActiveRecord::Migration[5.2]
  def change
    create_table :series_issues do |t|
      
    end
    add_reference :series_issues, :book, foreign_key: true, null: false
    add_reference :series_issues, :series, foreign_key: true, null: false
  end
end
