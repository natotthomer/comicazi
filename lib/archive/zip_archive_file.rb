class Archive::ZipArchiveFile < Archive::ArchiveFile

  FTYPES = {
    directory: :directory
  }

  def unarchive
    `zip -d #{@path_to_archive_file} __MACOSX\* .DS_Store`
    `zip -r #{@path_to_archive_file} -x "**/.DS_Store"`
    Zip::File.open(@path_to_archive_file) do |zip_file|

      
      # end
      
      # first build the directory :check:
      # then iterate over the entries
      # extract them, as needed
      # directory will already be built and we don't need to deal with it anymore
      
      # byebug
      directory_entry = zip_file.entries.find { |entry| entry.ftype == FTYPES[:directory] }
      @path_to_entry = directory_entry ? directory_entry.name : 'default_directory'

      @path_to_entry = File.join(TEMP_DIR_PATH, @path_to_entry)
      make_directory
      zip_file.each do |entry|
        puts "HELLO HELLOOOOOOOOOOOOOOOOOOOOOOO"
        next if should_be_ignored(entry)
        if entry.directory?
          @unarchived_path = @path_to_entry
          zip_file.extract(entry, @path_to_entry) { true }
        else
          zip_file.extract(entry, File.join(@path_to_entry, File.basename(entry.name))) { true }
        end

        @extracted = true
      end
    end
    @extracted ? @unarchived_path : false
  end

  private

  def make_directory
    if File.exists?(@path_to_entry)
      FileUtils.rm_rf(Dir.glob(@path_to_entry))
    end
    FileUtils.mkdir_p(@path_to_entry)
  end

  def should_be_ignored(entry)
    IGNORED_FILENAMES.any? { |ignored_filename| entry.name.end_with?(ignored_filename) }
  end
end