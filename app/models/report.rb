class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User"
  belongs_to :reported, class_name: "User"

  enum status: { waiting: 0, keep: 1, finish: 2 }

  validates :reason, presence: true, length: { minimum: 2, maximum: 255 }
end
