class Admin::BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def batch_new
    puts "YO WASSUP"
  end

  # def batch_show
  #   puts "AND WE'RE HERE"
  # end

  def batch_create
    puts "PARAMS:"
    puts params
    redirect_to "/admin/books/batch_show"
  end
end