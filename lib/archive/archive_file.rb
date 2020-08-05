class Archive::ArchiveFile

  TEMP_DIR_PATH = '/tmp/archive_contents'
  IGNORED_FILENAMES = [
    '.DS_Store'
  ].freeze

  attr_reader :path_to_archive_file, :path_to_entry
  attr_reader :unarchived_path

  def initialize(path_to_archive_file, extension)
    @path_to_archive_file = path_to_archive_file
    @extension = extension
    @extracted = false
    @unarchived_path = ''
  end

  def destroy_temp_files
    FileUtils.rm_rf(@unarchived_path)
  end

end