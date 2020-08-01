class Archive::RarArchiveFile < Archive::ArchiveFile
  
  def unarchive
    FileUtils.cp(@path_to_archive_file, "#{TEMP_DIR_PATH}/")
    File.rename(TEMP_DIR_PATH + "/" + File.basename(@path_to_archive_file), TEMP_DIR_PATH + "/" + File.basename(@path_to_archive_file) + '.cbr')
    @archive_copy_path = "#{TEMP_DIR_PATH}/#{File.basename(@path_to_archive_file)}.cbr"
    command = "unrar e #{@archive_copy_path} #{TEMP_DIR_PATH}/#{File.basename(@archive_copy_path, File.extname(@archive_copy_path))}/"
    puts command
    `#{command}`
    @extracted = true
    @unarchived_path = "#{TEMP_DIR_PATH}/#{File.basename(@archive_copy_path, File.extname(@archive_copy_path))}/"
  end
  
  def unarchived_files
    Dir.glob("#{TEMP_DIR_PATH}/*").sort
  end

end