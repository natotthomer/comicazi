class Series < ApplicationRecord

  include Rails.application.routes.url_helpers

  has_many :series_issues
  has_many :books, through: :series_issues
end
