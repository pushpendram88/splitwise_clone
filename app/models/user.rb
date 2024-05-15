# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :friends, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :paid_expenses, class_name: :SharedExpense, foreign_key: :paid_by_id, dependent: :destroy
  has_many :shared_expenses, class_name: :SharedExpense, foreign_key: :share_user_id, dependent: :destroy
  has_many :settle_expenses, class_name: :SettleExpense, foreign_key: :settle_by_id, dependent: :destroy

  def not_friends_with_me
    User.where.not(id: friend_ids << id)
  end

  def owed_expenses
    paid_expenses.sum(:amount).round(2)
  end

  def owe_expenses
    shared_expenses.sum(:amount).round(2)
  end

  def owe_user
    shared_expenses.joins(:paid_by_user).group( 'users.name', 'paid_by_id').sum(:amount).delete_if { |k,v| v.zero? }
  end

  def owed_user
    paid_expenses.joins(:share_by_user).group('users.name', 'share_user_id').sum(:amount).delete_if { |k,v| v.zero? }
  end

  def get_friend_ids
    friends.pluck(:friend_id)
  end

  def friend_ids
    get_friend_ids.concat(Friend.get_user_friends(id).pluck(:user_id))
  end

  def create_friends(friend_ids, curr_user)
    friend_ids = friend_ids.reject(&:blank?)
    friend_ids.each {|f_id| curr_user.friends.create(friend_id: f_id) if curr_user.id != f_id.to_i }
  end
end
