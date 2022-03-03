class BookFileFactory
  def initialize(file, book)
    @file = file
    @book = book
    @extension = File.extname(@file.path).delete('.')
  end
  
  def create
    build_and_unarchive_archive_file
    build_book_file_with_attachments

    path_to_extracted = @archive_file.path_to_extracted.end_with?('/') ? @archive_file.path_to_extracted : @archive_file.path_to_extracted + '/'
    path_to_cover_image = Dir["#{path_to_extracted}*"].sort.first

    @book_file.cover_image.attach(
      io: File.open(path_to_cover_image),
      filename: path_to_cover_image
    )
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

    puts @book_file.path_to_file
    @book_file.save
    @book_file
  end

  def build_attachments
    # something is happening here where we somehow use Dockerfile
    attach_file
    attach_cover_image
  end

  def attach_file
    puts @file
    path = @file.try(:path) || @file
    @book_file.file.attach(
      io: File.open(path),
      filename: File.basename(path)
    )
    @book_file.save
  end

  def attach_cover_image
    puts "THERE"
    # archive_file = Archive::ArchiveFileFactory.new(@book_file.path_to_file, @extension).create
    # archive_file.unarchive

    puts @archive_file.path_to_extracted
    puts @archive_file.path_to_extracted.end_with?('/')
    path_to_extracted = @archive_file.path_to_extracted
    path_to_extracted = @archive_file.path_to_extracted.end_with?('/') ? @archive_file.path_to_extracted : @archive_file.path_to_extracted + '/'
    byebug
    puts path_to_extracted
    path_to_cover_image = Dir["#{path_to_extracted}*"].sort.first
    puts Dir.foreach("#{path_to_extracted}") { |x| puts x}

    @book_file.cover_image.attach(
      io: File.open(path_to_cover_image),
      filename: path_to_cover_image
    )
    @archive_file.destroy_temp_files
  end
end
