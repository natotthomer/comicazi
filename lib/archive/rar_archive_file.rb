class Archive::RarArchiveFile < Archive::ArchiveFile
  
  def unarchive
    `unrar e "#{@path_to_archive_file}" "#{TEMP_DIR_PATH}"`
    @extracted = true
    TEMP_DIR_PATH
  end
  
  def unarchived_files
    Dir.glob("#{TEMP_DIR_PATH}/*").sort
  end

end