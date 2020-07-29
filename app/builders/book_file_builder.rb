require 'zip'

class BookFileBuilder

  TEMP_DIR_PATH = '/tmp/archive_contents'
  FILE_EXTENSIONS = %w( .jpg )

  def initialize(book_file_params)
    @book_file_params = book_file_params
    @tempfile_path = book_file_params[:file].try(:tempfile).try(:path) || book_file_params[:file]
  end

  def build
    extension = File.extname(@book_file_params[:file]).delete('.')
    @book_file = BookFile.new(book: @book_file_params[:book], extension: extension)
    build_attachments

    @book_file.save
    @book_file
  end

  private

  def build_attachments
    attach_file
    attach_cover_image
  end

  def attach_cover_image
    archive_file = Archive::ArchiveFileBuilder.new(@book_file.path_to_file, extension: @book_file.extension).build
    puts "THERE"
    archive_file.unarchive

    path_to_cover_image = Dir["#{archive_file.unarchived_path}*"].sort.first
    puts path_to_cover_image
    @book_file.cover_image.attach(
      io: File.open(path_to_cover_image),
      filename: path_to_cover_image
    )
    archive_file.destroy_temp_files
  end

  def attach_file
    path = @book_file_params[:file].try(:path) || @book_file_params[:file]

    @book_file.file.attach(
      io: File.open(path),
      filename: File.basename(path)
    )
    @book_file.save
  end

end
