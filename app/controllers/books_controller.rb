class BooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @book = Book.new
  end
  
  def create
    create_params = book_params

    @book = BookFactory.new(
      book_params[:title],
      book_params[:issue_number],
      book_params[:file],
    ).create

    if @book
      puts 'HELLOOOOOO'
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
    params.require(:book).permit(:title, :issue_number, :file)
  end
end
