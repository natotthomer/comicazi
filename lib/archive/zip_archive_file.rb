class Archive::ZipArchiveFile < Archive::ArchiveFile

  FTYPES = {
    directory: :directory
  }

  def unarchive
    `zip -d #{@path} __MACOSX\* .DS_Store`
    `zip -r #{@path} -x "**/.DS_Store"`
    Zip::File.open(@path) do |zip_file|

      
      # end
      
      # first build the directory :check:
      # then iterate over the entries
      # extract them, as needed
      # directory will already be built and we don't need to deal with it anymore
      
      # byebug
      directory_entry = zip_file.entries.find { |entry| entry.ftype == FTYPES[:directory] }
      @path_to_extracted = directory_entry ? directory_entry.name : 'default_directory'

      @path_to_extracted = File.join(TMP_ARCHIVE_CONTENTS_PATH, @path_to_extracted)
      make_directory
      zip_file.each do |entry|
        puts "HELLO HELLOOOOOOOOOOOOOOOOOOOOOOO"
        next if should_be_ignored(entry)
        if entry.directory?
          @unarchived_path = @path_to_extracted
          zip_file.extract(entry, @path_to_extracted) { true }
        else
          zip_file.extract(entry, File.join(@path_to_extracted, File.basename(entry.name))) { true }
        end

        @extracted = true
      end
    end
    @extracted ? @unarchived_path : false
  end

  private

  def make_directory
    if File.exists?(@path_to_extracted)
      FileUtils.rm_rf(Dir.glob(@path_to_extracted))
    end
    FileUtils.mkdir_p(@path_to_extracted)
  end

  def should_be_ignored(entry)
    IGNORED_FILENAMES.any? { |ignored_filename| entry.name.end_with?(ignored_filename) }
  end
end