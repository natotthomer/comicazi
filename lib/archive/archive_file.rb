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

  def image_files
    # path_to_extracted = @archive_file.path_to_extracted
    path_to_extracted = self.path_to_extracted.end_with?('/') ? self.path_to_extracted : self.path_to_extracted + '/'
    Dir["#{path_to_extracted}*"].sort.select { |file| BookFileFactory::IMAGE_MIME_TYPES.include?(MimeMagic.by_path(file).type) }
  end

end