class SeriesIssue < ApplicationRecord

  include Rails.application.routes.url_helpers

  belongs_to :series
  belongs_to :book
end
