class BookFactory
  def initialize(name, issue_number, file)
    @name = name
    @issue_number = issue_number
    @file = file
  end

  def create
    has_proper_book_params?

    Book.transaction do
      @book = Book.create!(name: @name, issue_number: @issue_number)
      BookFileFactory.new(@file, @book).create
      @book
    end
  end

  private

  def has_proper_book_params?
    if @name.blank? || @issue_number.blank?
      raise ActiveRecord::RecordInvalid
    end
  end
end
