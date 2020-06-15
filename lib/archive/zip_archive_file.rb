class Archive::ZipArchiveFile < Archive::ArchiveFile

  def unarchive
    Zip::File.open(@path_to_archive_file) do |zip_file|
      zip_file.each do |entry|
        puts entry.name
        puts File.join(TEMP_DIR_PATH, entry.name)
        @unarchived_path = File.join(TEMP_DIR_PATH, entry.name)
        if entry.directory?
          if File.exists?(@unarchived_path)
            FileUtils.rm_rf(Dir.glob(@unarchived_path))
          end
          FileUtils.mkdir_p(File.dirname(@unarchived_path))
        end

        zip_file.extract(entry, @unarchived_path) { true }
        @extracted = true
      end
    end
    @extracted ? @unarchived_path : false
  end

end