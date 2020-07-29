class Archive::ArchiveFile

  TEMP_DIR_PATH = '/tmp/archive_contents'

  attr_reader :path_to_archive_file
  attr_reader :unarchived_path

  def initialize(path_to_archive_file, extension)
    @extracted = false
    @unarchived_path = ''
    @path_to_archive_file = path_to_archive_file
    @extension = extension
    puts path_to_archive_file
  end

  def destroy_temp_files
    FileUtils.rm_rf(@unarchived_path)
  end

end