class Admin::BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def batch_new
  end
  
  def batch_create
    @books = Book.batch_create(batch_book_params)

    render template: "admin/books/batch_show", locals: { books: @books }
  end

  def batch_show
    @books = params[:books]
    render_template "batch_show"
  end
  
  private
  
  def batch_book_params
    params.permit(:zip, :metadata)
  end
end