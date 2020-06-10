class BookFileBuilder

  TEMP_DIR_NAME = '/tmp/archive_contents'
  FILE_EXTENSIONS = %w( .jpg )

  def initialize(book_file_params)
    puts book_file_params
    @book_file_params = book_file_params

    @tempfile_path = book_file_params[:file].try(:tempfile).try(:path) || book_file_params[:file]
  end

  def create
    @book_file = BookFile.new(book: @book_file_params[:book])
    # @book_file = BookFile.create(@book_file_params)
    build_attachments

    @book_file.save
    @book_file
  end

  private

  def build_attachments
    attach_file
    attach_cover_image
  end

  def unrar_file
    `unrar e "#{@tempfile_path}" "#{TEMP_DIR_NAME}/"`
    @unrarred_files = Dir.glob("#{TEMP_DIR_NAME}/*#{FILE_EXTENSIONS[0]}").sort

    # Could also do this in JS and optionally provide a confirmed cover image filename
    @first_image_filename = @unrarred_files.first
  end

  def attach_cover_image
    unrar_file
    @book_file.cover_image.attach(
      io: File.open(@first_image_filename),
      filename: @first_image_filename
    )
    destroy_unrar
  end

  def attach_file
    path = @book_file_params[:file].try(:path) || @book_file_params[:file]
    
    @book_file.file.attach(
      io: File.open(path),
      filename: File.basename(path)
    )
    destroy_unrar
  end

  def destroy_unrar
    Dir.foreach(TEMP_DIR_NAME) do |f|
      fn = File.join(TEMP_DIR_NAME, f)
      File.delete(fn) if f != '.' && f != '..'
    end
  end

end
