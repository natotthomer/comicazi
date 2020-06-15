class Archive::ZipArchiveFile < Archive::ArchiveFile

  def unarchive
    `zip -d #{@path_to_archive_file} __MACOSX\* .DS_Store`
    Zip::File.open(@path_to_archive_file) do |zip_file|
      zip_file.each do |entry|
        @path_to_entry = File.join(TEMP_DIR_PATH, entry.name)

        if entry.directory?
          @unarchived_path = @path_to_entry

          if File.exists?(@path_to_entry)
            FileUtils.rm_rf(Dir.glob(@path_to_entry))
          end

          FileUtils.mkdir_p(File.dirname(@path_to_entry))
        end

        zip_file.extract(entry, @path_to_entry) { true }
        @extracted = true
      end
    end
    @extracted ? @unarchived_path : false
  end

end