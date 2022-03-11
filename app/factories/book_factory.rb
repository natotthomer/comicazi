class BookFactory
  def initialize(title, issue_number, file)
    @title = title
    @issue_number = issue_number
    @file = file
  end

  def create
    has_proper_book_params?

    Book.transaction do
      @book = Book.create!(title: @title, issue_number: @issue_number)
      build_attachments
      @book
    end
  end

  private

  def build_attachments
    @extension = File.extname(@file.path).delete('.')

    build_and_unarchive_archive_file
    attach_images
  end

  def build_and_unarchive_archive_file
    @archive_file = Archive::ArchiveFileFactory.new(@file.path, @extension).create
    @archive_file.unarchive
  end

  def attach_images
    @archive_file.image_files.map do |image_file|
      @book.images.attach(
        io: File.open(image_file),
        filename: image_file
      )

      @book.save
      @book
    end

    @archive_file.destroy_temp_files
  end

  def has_proper_book_params?
    if @title.blank? || @issue_number.blank?
      raise ActiveRecord::RecordInvalid
    end
  end
end
