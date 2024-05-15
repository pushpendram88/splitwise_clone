require 'rails_helper'

RSpec.describe SettleExpense, type: :model do
  let(:user) { create(:user, email: 'test@example.com', password: 'password123', password_confirmation: 'password123') }

  describe 'associations' do
    it { should belong_to(:settle_by) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
  end

end
