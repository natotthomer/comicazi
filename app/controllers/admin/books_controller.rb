class Admin::BooksController < ApplicationController
  def index
    @books = Book.all
  end
end