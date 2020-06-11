class ZipFile < ArchiveFile

  def file
    Zip::File.open(@path)
  end
  
  private

  def unarchive
    file do |zip_file|
      zip_file.each do |entry|
        puts entry.name
        path_to_unarchive_to = File.join(TEMP_DIR_NAME, entry.name)
        puts path_to_unarchive_to
        FileUtils.mkdir_p(File.dirname(path_to_unarchive_to))
        unless File.exist?(path_to_unarchive_to)
          zip_file.extract(entry, path_to_unarchive_to)
        end
      end
    end
  end
end