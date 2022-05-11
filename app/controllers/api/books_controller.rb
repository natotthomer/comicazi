class Api::BooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    render json: Book.find(params[:id])
  end

  def index
    books = Book.all.map do |book|
      cover = url_for book.images.first
      {
        title: book.title,
        issue_number: book.issue_number,
        series: book.series,
        cover: cover,
        id: book.id
      }
    end

    render json: books
  end

  def create
    puts book_params
    # create_params = book_params

    # @book = BookFactory.new(
    #   book_params[:title],
    #   book_params[:issue_number],
    #   book_params[:file],
    # ).create

    # if @book
    #   render json: @book
    # else
    #   render json: @book.errors
    # end
    render json: { hello: 'world' }
  end

  private

  def book_params
    params.require(:book).permit(:title, :issue_number, :file)
  end
end

