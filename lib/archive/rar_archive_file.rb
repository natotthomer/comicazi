class Archive::RarArchiveFile < Archive::ArchiveFile
  
  def unarchive
    FileUtils.cp(@path_to_archive_file, "#{TEMP_DIR_PATH}/")

    if !has_extension
      File.rename(TEMP_DIR_PATH + "/" + File.basename(@path_to_archive_file), TEMP_DIR_PATH + "/" + File.basename(@path_to_archive_file) + '.cbr')
    end
    @archive_copy_path = "#{TEMP_DIR_PATH}/#{File.basename(@path_to_archive_file)}.cbr"
    command = "unrar e #{@archive_copy_path} #{TEMP_DIR_PATH}/#{File.basename(@archive_copy_path, File.extname(@archive_copy_path))}/"
    puts command
    `#{command}`
    @extracted = true
    @path_to_entry = "#{TEMP_DIR_PATH}/#{File.basename(@archive_copy_path, File.extname(@archive_copy_path))}/"
  end
  
  def unarchived_files
    Dir.glob("#{TEMP_DIR_PATH}/*").sort
  end

  private
  
  def has_extension
    ['.cbr', '.rar'].any? { |extension| @path_to_archive_file.end_with?(extension) }
  end

end