class Archive::RarArchiveFile < Archive::ArchiveFile
  
  def unarchive
    byebug
    @unarchived_path = "#{TEMP_DIR_PATH}/#{File.basename(@path_to_archive_file)}"
    `unrar e #{@path_to_archive_file} #{@unarchived_path}`
    @extracted = true
    @unarchived_path
  end
  
  def unarchived_files
    Dir.glob("#{TEMP_DIR_PATH}/*").sort
  end

end