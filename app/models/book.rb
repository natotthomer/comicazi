require 'zip'
require 'csv'

class Book < ApplicationRecord

  include Rails.application.routes.url_helpers

  has_many_attached :images

  def to_hash
    {
      title: self.title,
      issue_number: self.issue_number
    }
  end

  # Class methods

  def self.make(params)
    book = Book.create(params)

    if book.save
      book
    end
  end

  def self.batch_create(params)
    zip = params[:zip]
    parsed_csv = CSV.read(params[:metadata].try(:tempfile).try(:path))

    books_created = []
    archive_file = Archive::ArchiveFileFactory.new(zip.path, 'zip').create
    archive_file.unarchive
    # unarchived_files = Dir["#{archive_file.path_to_extracted}*"].sort
    unarchived_files = Dir.entries(archive_file.path_to_extracted).select { |entry| !['.','..'].include?(entry) }.sort

    if unarchived_files.none? { |file| file.start_with?("/tmp/archive_contents/#{File.basename(zip.original_filename, File.extname(zip.original_filename))}/") }
      unarchived_files = unarchived_files.map { |file| file.prepend("/tmp/archive_contents/#{File.basename(zip.original_filename, File.extname(zip.original_filename))}/")}
    end

    unarchived_files.each_with_index do |filepath, index|
      csv_row_data = parsed_csv[index + 1]
      book = Book.create({ title: csv_row_data[0], issue_number: csv_row_data[1] })

      if book.save
        books_created << book
      end
    end
    books_created
  end

end
