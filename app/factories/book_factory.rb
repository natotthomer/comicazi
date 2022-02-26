class BookFactory
  def initialize(name, issue_number, book_file)
    @name = name
    @issue_number = issue_number
    @book_file = book_file
  end

  def create
    has_proper_book_params?

    Book.transaction do
      @book = Book.create!(name: @name, issue_number: @issue_number)
    end
  end

  private

  def has_proper_book_params?
    if @name.blank? || @issue_number.blank?
      raise ActiveRecord::RecordInvalid
    end
  end
end