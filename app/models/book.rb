require 'zip'
require 'csv'

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
    archive_file = Archive::ArchiveFileBuilder.new(zip.path, 'zip').build
    archive_file.unarchive
    # unarchived_files = Dir["#{archive_file.path_to_entry}*"].sort
    unarchived_files = Dir.entries(archive_file.path_to_entry).select { |entry| !['.','..'].include?(entry) }.sort

    if unarchived_files.none? { |file| file.start_with?("/tmp/archive_contents/#{File.basename(zip.original_filename, File.extname(zip.original_filename))}/") }
      unarchived_files = unarchived_files.map { |file| file.prepend("/tmp/archive_contents/#{File.basename(zip.original_filename, File.extname(zip.original_filename))}/")}
    end

    unarchived_files.each_with_index do |filepath, index|
      puts 'YOOOOO'
      csv_row_data = parsed_csv[index + 1]
      book = Book.create({ name: csv_row_data[0], issue_number: csv_row_data[1] })

      if book.save
        BookFileBuilder.new({ book: book, file: filepath, path_to_entry: archive_file.path_to_entry }).build
        # BookFile.build_with_attachments({ book: book, file: filepath, path_to_entry: archive_file.path_to_entry })
        books_created << book
      end
    end
    books_created
  end

end
