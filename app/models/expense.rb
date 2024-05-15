# frozen_string_literal: true

class Expense < ApplicationRecord
  include ExpenseLogic
  attr_accessor :shared_user_ids
  attr_accessor :shared_user_amounts

  belongs_to :user
  belongs_to :paid_by, class_name: 'User', foreign_key: 'paid_by_id'
  has_many :shared_expenses, dependent: :destroy

  accepts_nested_attributes_for :shared_expenses

  validates :amount, :description, :paid_by, presence: true
  validates :amount, numericality: { greater_than: 0 }

  before_create do
    self.sub_total = amount
  end

  def self.expense(user)
    where(paid_by: user.id).pluck(:id)
  end
end
