class Archive::ZipArchiveFile < Archive::ArchiveFile

  def unarchive
    Zip::File.open(filepath) do |zip_file|
      zip_file.each do |entry|
        puts entry.name
        puts File.join(TEMP_DIR_PATH, entry.name)
        if entry.directory?
          @unarchived_path = File.join(destination, entry.name)
          if File.exists(entry.name)
            FileUtils.rm_rf(Dir.glob("#{entry.name)}"))
          end
          FileUtils.mkdir_p(File.dirname(f_path))
        end
        
        zip_file.extract(entry, f_path)
        @extracted = true
      end
    end
    @extracted ? @unarchived_path : false
  end

end