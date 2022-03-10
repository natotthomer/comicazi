class BooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @book = Book.new
  end
  
  def create
    create_params = book_params

    @book = BookFactory.new(
      book_params[:name],
      book_params[:issue_number],
      book_params[:file],
    ).create
    
    # @book = Book.make(book_params)
    if @book
      # @file = BookFileBuilder.new(book_file_params).build
      # @file = BookFile.build_with_attachments(book_file_params)
      redirect_to(@book)
    else
      render "new"
    end
  end

  def index
    @books = Book.all
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to(@book)
    else
      render "edit"
    end
  end

  def show
    @book = Book.find(params[:id])
    archive_file = Archive::ArchiveFileFactory.new(@book.archive_file, @book.book_file.extension).create
    archive_file.unarchive
    @image_files = archive_file.image_files
    puts @image_files
  end
  
  private

  def book_params
    params.require(:book).permit(:name, :issue_number, :file)
  end

  # def book_file_params
  #   params.require(:book).permit(:file).merge({ book: @book })
  # end
end
