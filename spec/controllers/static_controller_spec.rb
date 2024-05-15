# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticController, type: :controller do
  let(:user) { create(:user) }
  # let(:expense) { create(:expense) }

  before(:each) do
    sign_in user
  end

  describe 'GET #dashboard' do
    it 'assign owe_user' do
      get :dashboard
      expect(assigns(:you_owe_user)).to eq(user.owe_user)
    end

    it 'assigns owed_user' do
      get :dashboard
      expect(assigns(:you_are_owed_user)).to eq(user.owed_user)
    end

    it 'renders the dashboard template' do
      get :dashboard
      expect(response).to render_template(:dashboard)
    end
  end

  describe 'GET #person' do
    it 'renders the person template' do
      get :person, params: { id: user.id }
      expect(response).to render_template(:person)
    end
  end

  describe 'private methods' do
    describe '#get_friends' do
      it 'assigns @users' do
        get :dashboard
        expect(assigns(:users)).to eq(User.all)
      end

      it 'assigns @friends' do
        get :dashboard
        expect(assigns(:friends)).to eq(User.where(id: user.friend_ids.uniq))
      end
    end

    describe '#expense' do
      it 'assigns @expense' do
        get :dashboard
        expect(assigns(:expense)).to be_a_new(Expense)
      end
    end
  end
end
