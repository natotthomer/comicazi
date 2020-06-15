require 'zip'

class BookFileBuilder

  TEMP_DIR_PATH = '/tmp/archive_contents'
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

  def unarchive_file
    file_ext = File.extname(@tempfile_path)

    if file_ext == '.cbr'
      unrar_file
    else
      unzip_file
    end
  end

  def unrar_file
    `unrar e "#{@tempfile_path}" "#{TEMP_DIR_PATH}/"`
    @unrarred_files = Dir.glob("#{TEMP_DIR_PATH}/*#{FILE_EXTENSIONS[0]}").sort

    # Could also do this in JS and optionally provide a confirmed cover image filename
    @first_image_filename = @unrarred_files.first
  end

  def unzip_file
    Zip::File.open(@tempfile_path) do |zip_file|
      zip_file.each do |entry|
        puts entry.name
        f_path = File.join(TEMP_DIR_PATH, entry.name)
        puts f_path
        FileUtils.mkdir_p(File.dirname(f_path))
        unless File.exist?(f_path)
          zip_file.extract(entry, f_path)
        end
      end
    end
    @first_image_filename = Dir.glob("#{File.dirname(@tempfile_path)}/*").sort.first
  end

  def attach_cover_image
    # unarchive_file
    byebug
    archive_file = Archive::ArchiveFileBuilder.new(@book_file.path_to_file, extension: @book_file.file.filename.extension).build
    byebug
    archive_file.unarchive

    path_to_cover_image = Dir[archive_file.unarchived_path].sort.first
    @book_file.cover_image.attach(
      io: File.open(path_to_cover_image),
      filename: path_to_cover_image
    )
    # destroy_temp_folder_contents
  end

  def attach_file
    path = @book_file_params[:file].try(:path) || @book_file_params[:file]
    
    @book_file.file.attach(
      io: File.open(path),
      filename: File.basename(path)
    )
    @book_file.save
    # destroy_temp_folder_contents
  end

  def destroy_temp_folder_contents
    byebug
    Dir.foreach("#{File.dirname(@tempfile_path)}/*") do |file|
      filename = File.join(@tempfile_path, file)
      if File.directory?(filename)
        FileUtils.rm_rf(Dir.glob("#{filename[0..-2]}*"))
      else
        File.delete(filename) if file != '.' && file != '..'
      end
    end
  end

end
