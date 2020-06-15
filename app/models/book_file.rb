class BookFile < ApplicationRecord

  belongs_to :book
  has_one_attached :file
  has_one_attached :cover_image

  after_create

  def self.build_with_attachments(params)
    BookFileBuilder.new(params).build
  end

  def path_to_file
    ActiveStorage::Blob.service.path_for(file.key)
  end

end
