class BooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @book = Book.new
  end
  
  def create
    @book = Book.make(book_params)
    if @book
      # @file = BookFileBuilder.new(book_file_params).build
      @file = BookFile.build_with_attachments(book_file_params)
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
  end
  
  private

  def book_params
    params.require(:book).permit(:name, :issue_number)
  end

  def book_file_params
    params.require(:book).permit(:file).merge({ book: @book })
  end
end
