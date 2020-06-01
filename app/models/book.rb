class Book < ApplicationRecord

  has_one :book_file

  def to_hash
    {
      name: self.name,
      issue_number: self.issue_number,
    }
  end
end
