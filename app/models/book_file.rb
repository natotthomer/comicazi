class BookFile < ApplicationRecord
  belongs_to :book
  has_one_attached :file
  has_one_attached :cover_image

  after_create

  def self.build_with_cover_image(params)
    BookFileBuilder.new(params).create
  end

  def path_for_file
    ActiveStorage::Blob.service.path_for(file.key)
  end

end
