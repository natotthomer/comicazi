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

  def self.unzip_file (file, destination)
    extracted = false
    
    unzipped_path = ''
    Zip::File.open(file) { |zip_file|
      zip_file.each { |f|
        puts f.name
        unzipped_path = File.join(destination, f.name) unless unzipped_path.present?
        puts File.join(destination, f.name)
        f_path = File.join(destination, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        unless File.exist?(f_path)
          zip_file.extract(f, f_path)
          extracted = true if File.exist?(f_path)
        end
      }
    }
    extracted ? unzipped_path : false
  end

  def self.batch_create(params)
    zip = params[:zip]
    parsed_csv = CSV.read(params[:metadata].try(:tempfile).try(:path))

    books_created = []

    unzipped_path = Book.unzip_file(zip.path, 'temp')
    unzipped_files = Dir["#{unzipped_path}*"]
    
    unzipped_files.each_with_index do |filepath, index|
      csv_row_data = parsed_csv[index + 1]
      book = Book.create({ name: csv_row_data[0], issue_number: csv_row_data[1] })
      if book.save
        BookFile.build_with_attachments({ book: book, file: filepath })
        books_created << book
      end
    end
    books_created
  end
end
