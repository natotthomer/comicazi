require 'zip'

class BookFileBuilder

  TEMP_DIR_PATH = '/tmp/archive_contents'
  FILE_EXTENSIONS = %w( .jpg )

  def initialize(book_file_params)
    @book_file_params = book_file_params
    @tempfile_path = book_file_params[:path_to_entry] ? File.join(book_file_params[:path_to_entry], book_file_params[:file]) : book_file_params[:file].try(:tempfile).try(:path) || book_file_params[:file]
  end

  def build
    extension = File.extname(@book_file_params[:file]).delete('.')
    @book_file = BookFile.new(book: @book_file_params[:book], extension: extension)
    build_attachments

    puts @book_file.path_to_file
    @book_file.save
    @book_file
  end

  private

  def build_attachments
    # something is happening here where we somehow use Dockerfile
    attach_file
    attach_cover_image
  end

  def attach_file
    byebug
    path = @book_file_params[:file].try(:path) || @book_file_params[:file]
    @book_file.file.attach(
      io: File.open(path),
      filename: File.basename(path)
    )
    @book_file.save
  end

  def attach_cover_image
    puts "THERE"
    archive_file = Archive::ArchiveFileBuilder.new(@book_file.path_to_file, @book_file.extension).build
    archive_file.unarchive

    path_to_cover_image = Dir["#{archive_file.path_to_entry}*"].sort.first

    @book_file.cover_image.attach(
      io: File.open(path_to_cover_image),
      filename: path_to_cover_image
    )
    archive_file.destroy_temp_files
  end

end
