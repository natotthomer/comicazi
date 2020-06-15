class Archive::ArchiveFile

  TEMP_DIR_PATH = '/tmp/archive_contents'

  attr_reader :path_to_archive_file
  attr_reader :unarchived_path

  def initialize(path_to_archive_file)
    @extracted = false
    @unarchived_path = ''
    @path_to_archive_file = path_to_archive_file
  end

  def destroy_temp_files
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