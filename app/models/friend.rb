# frozen_string_literal: true

class Friend < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  scope :get_user_friends, -> (user_id) { where(friend_id: user_id) }
  scope :get_already_created, -> (user_id, friend_id) { where(user_id: [user_id, friend_id], friend_id: [user_id, friend_id]) }

  validate :validate_friend

  private

  def validate_friend
    errors.add(:base, "Alreday created") if Friend.get_already_created(self.user_id, self.friend_id).present?
  end
end
