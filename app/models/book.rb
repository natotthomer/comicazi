class Book < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one :book_file

  def to_hash
    {
      name: self.name,
      issue_number: self.issue_number
    }
  end

  def cover_image 
    rails_blob_path(self.book_file.cover_image, disposition: "attachment", only_path: true)
  end

  # Class methods

  def self.batch_create
    
  end
end
