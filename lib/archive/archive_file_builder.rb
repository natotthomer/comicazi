class Archive::ArchiveFileBuilder
  
  def initialize(path_to_archive_file)
    @path_to_archive_file = path_to_archive_file
  end

  def build
    case extension
    when "zip", "cbz"
      Archive::ZipArchiveFile.new(@path_to_archive_file)
    when "rar", "cbr"
      Archive::RarArchiveFile.new(@path_to_archive_file)
    else
      ArgumentError.new("File type not supported")
    end
  end
    
end