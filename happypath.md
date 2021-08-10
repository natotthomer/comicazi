* CSV.read –- read CSV from params
* Archive::ArchiveFileBuilder.new -- pass the path and the zip (in this case, always 'zip')
  * use the extension to determine which type of ArchiveFile to use
  * pass the extension & full filepath (including filename and extension) to initialize specific ArchiveFile subclass or raise ArgumentError
  * --> ArchiveFile.build -- 