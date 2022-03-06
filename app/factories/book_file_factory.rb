class BookFileFactory
  IMAGE_MIME_TYPES = %w( image/jpeg )

  def initialize(file, book)
    @file = file
    @book = book
    @extension = File.extname(@file.path).delete('.')
  end
  
  def create
    build_and_unarchive_archive_file
    build_book_file_with_attachments

    @archive_file.destroy_temp_files
  end

  private

  def build_and_unarchive_archive_file
    @archive_file = Archive::ArchiveFileFactory.new(@file.path, @extension).create
    @archive_file.unarchive
  end

  def build_book_file_with_attachments
    @book_file = BookFile.new(book: @book, extension: @extension)
    build_attachments

    @book_file.save
    @book_file
  end

  def build_attachments
    # something is happening here where we somehow use Dockerfile
    attach_file
    attach_cover_image
  end

  def attach_file
    path = @file.try(:path) || @file
    @book_file.file.attach(
      io: File.open(path),
      filename: File.basename(path)
    )
    @book_file.save
  end

  def attach_cover_image
    path_to_extracted = @archive_file.path_to_extracted
    path_to_extracted = @archive_file.path_to_extracted.end_with?('/') ? @archive_file.path_to_extracted : @archive_file.path_to_extracted + '/'
    image_files_in_archive = Dir["#{path_to_extracted}*"].sort.select { |file| IMAGE_MIME_TYPES.include?(MimeMagic.by_path(file).type) }
    path_to_cover_image = image_files_in_archive.first

    @book_file.cover_image.attach(
      io: File.open(path_to_cover_image),
      filename: path_to_cover_image
    )

    @archive_file.destroy_temp_files
  end
end
