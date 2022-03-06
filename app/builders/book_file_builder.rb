require 'zip'

class BookFileBuilder

  TMP_ARCHIVE_CONTENTS_PATH = '/tmp/archive_contents'
  FILE_EXTENSIONS = %w( .jpg )
  IMAGE_MIME_TYPES = %w( image/jpeg )

  def initialize(book_file_params)
    @book_file_params = book_file_params
    @tempfile_path = book_file_params[:path_to_extracted] ? File.join(book_file_params[:path_to_extracted], book_file_params[:file]) : book_file_params[:file].try(:tempfile).try(:path) || book_file_params[:file]
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
    # something is happening here where we somehow use Dockerfile
    attach_file
    attach_cover_image
  end

  def attach_file
    path = @book_file_params[:file].try(:path) || @book_file_params[:file]
    @book_file.file.attach(
      io: File.open(path),
      filename: File.basename(path)
    )
    @book_file.save
  end

  def attach_cover_image
    archive_file = Archive::ArchiveFileFactory.new(@book_file.path_to_file, @book_file.extension).create
    archive_file.unarchive
    path_to_extracted = archive_file.path_to_extracted.end_with?('/') ? archive_file.path_to_extracted : archive_file.path_to_extracted + '/'

    image_files_in_archive = Dir["#{path_to_extracted}*"].sort.select { |file| IMAGE_MIME_TYPES.include?(MimeMagic.by_path(file).type) }
    path_to_cover_image = image_files_in_archive.first

    @book_file.cover_image.attach(
      io: File.open(path_to_cover_image),
      filename: path_to_cover_image
    )
    archive_file.destroy_temp_files
  end

end
