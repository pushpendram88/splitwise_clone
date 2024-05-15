# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  let(:user) { create(:user) }
  let(:shared_user) { create(:user) }
  let(:expense) { create(:expense) }
  # render_views
  before(:each) do
    sign_in create(:user)
  end

  describe 'POST #create ' do
    context 'with valid parameters and un-equal amount' do
      subject do
        post :create,
             params: { expense: { description: 'test', amount: 100, paid_by_id: user.id, shared_user_ids: [shared_user.id] },
                       shared_user_amounts: { shared_user.id => 100 } }
      end

      it 'redirects to root_path' do
        expect(subject).to have_http_status(:redirect)
      end

      it 'creates expenses with un-equal' do
        expect { subject }.to change(Expense, :count).from(0).to(1)
      end
    end

    context 'with valid parameters and equal amount' do
      subject do
        post :create,
             params: { expense: { description: 'test', amount: 100, paid_by_id: user.id, shared_user_ids: [shared_user.id] },
                       shared_user_amounts: { shared_user.id => '' } }
      end

      it 'redirects to root_path' do
        expect(subject).to have_http_status(:redirect)
      end

      it 'creates expenses with equal' do
        expect { subject }.to change(Expense, :count).from(0).to(1)
      end
    end

    context 'with invalid parameters' do
      subject do
        post :create,
             params: { expense: { description: '', amount: nil, paid_by_id: user.id, shared_user_ids: [shared_user.id] },
                       shared_user_amounts: { shared_user.id => '' } }
      end

      it 'does not create a new expense' do
        expect { subject }.not_to change(Expense, :count)
      end

      it 'redirects to root_path' do
        expect(subject).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested expense as @expense' do
      get :edit, params: { id: expense.id }, xhr: true
      expect(assigns(:expense)).to eq(expense)
    end

    it 'renders the edit template' do
      get :edit, params: { id: expense.id }, xhr: true
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT #update' do
    let(:updated_description) { 'Updated expense description' }

   context 'with valid parameters' do
      it 'updates the expense and redirects to root path' do
        patch :update, params: { id: expense.id, expense: { description: 'New Description' } }, xhr: true
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      it 're-renders the edit template' do
        put :update, params: { id: expense.id, expense: { description: '' } }, xhr: true
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET #settle_up' do
    it 'assigns the current user\'s owed users as @you_are_owed_user' do
      get :settle_up, xhr: true
      expect(assigns(:you_are_owed_user)).to eq(user.owe_user)
    end

    it 'renders the settle_up template' do
      get :settle_up, xhr: true
      expect(response).to render_template(:settle_up)
    end
  end

  describe "PUT #update_settle_expenses" do
    context "with valid params" do
      it "redirect to with updated data" do
        put :update_settle_expenses, params: { settle_to_id: user.id, amount: 50, additional_note: "settled" }
        expect(subject).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      it "sets an alert flash message" do
        put :update_settle_expenses, params: { settle_to_id: user.id, amount: -100 }
        expect(flash[:alert]).to eq('unable to perform')
      end
    end
  end

  describe 'private #set_expense' do
    it 'assigns the requested expense to @expense' do
      allow(controller).to receive(:params).and_return({ id: expense.id })
      controller.send(:set_expense)
      expect(assigns(:expense)).to eq(expense)
    end
  end
end