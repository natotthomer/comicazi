class Archive::ArchiveFileFactory

  def initialize(path, extension)
    @path = path
    @extension = extension
  end

  def create
    case @extension
    when "zip", "cbz"
      Archive::ZipArchiveFile.new(@path, @extension)
    when "rar", "cbr"
      Archive::RarArchiveFile.new(@path, @extension)
    else
      ArgumentError.new("File type not supported")
    end
  end

end