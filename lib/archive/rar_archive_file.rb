class Archive::RarArchiveFile < Archive::ArchiveFile
  def unarchive
    extract_archive
    @extracted = true
  end
  
  def unarchived_files
    Dir.glob("#{TMP_ARCHIVE_CONTENTS_PATH}/*").sort
  end

  def basename
    File.basename(@path, '.*')
  end
  
  def basename_with_extension
    File.basename(@path)
  end
  
  def path_to_extracted
    # puts "BASENAAAAAAAAAAME"
    # puts @path
    # puts basename
    # puts basename_with_extension
    # puts "++++++++++++++++++++++"
    "#{TMP_ARCHIVE_CONTENTS_PATH}/#{basename}/"
  end

  private
  
  def archive_copy_path
    "#{TMP_ARCHIVE_CONTENTS_PATH}/#{basename_with_extension}"
  end
  
  def extract_archive
    byebug
    `unrar e #{@path} #{path_to_extracted}`
  end
end