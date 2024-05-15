class SettleExpense < ApplicationRecord
  belongs_to :settle_by, class_name: :User, foreign_key: :settle_by_id

  validates :amount, presence: true
  validates :amount, numericality: { only_numeric: true }
end
