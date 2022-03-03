class Archive::ArchiveFile

  TMP_ARCHIVE_CONTENTS_PATH = '/tmp/archive_contents'
  IGNORED_FILENAMES = [
    '.DS_Store'
  ].freeze
  COMIC_BOOK_ARCHIVE_EXTENSIONS = [
    'cbr',
    'cbz'
  ]

  attr_reader :path, :path_to_extracted
  attr_reader :unarchived_path

  def initialize(path, extension)
    @path = path
    @extension = extension
    @extracted = false
    @unarchived_path = ''
  end

  def is_comic_book_archive_file?
    COMIC_BOOK_ARCHIVE_EXTENSIONS.include?(@extension)
  end

  def destroy_temp_files
    FileUtils.rm_rf(@unarchived_path)
  end

end