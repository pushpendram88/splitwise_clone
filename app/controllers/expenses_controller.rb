# frozen_string_literal: true

class ExpensesController < ApplicationController
  before_action :set_expense, except: [:create, :edit]
  def create
    expense = Expense.create_with_participants(expense_params, params['expense']['shared_user_ids'],
                                               params['shared_user_amounts'], current_user)
    if expense
      flash[:notice] = 'expense create successfully!'
    else
      flash[:alert] = "unable to create expense"
    end
    redirect_to root_path
  end

  def edit
    @expense = Expense.includes(shared_expenses: :share_by_user).find_by_id(params[:id])
  end

  def update
    render :edit unless @expense.update(expense_params)
  end

  def settle_up
    @you_are_owed_user = current_user.owe_user
  end

  def update_settle_expenses
    settle = Expense.settle_expense(settle_param, current_user)

    if settle
      flash[:notice] = 'Expense settled.'
    else
      flash[:alert] = "unable to perform"
    end
    redirect_to root_path
  end

  private

  def expense_params
    params.require(:expense).permit(:description, :amount, :paid_by_id, :tax, :tip, :sub_total, shared_expenses_attributes: [:id, :amount])
  end

  def settle_param
    params.permit(:settle_to_id, :amount, :additional_note)
  end

  def set_expense
    @expense = Expense.find_by_id(params[:id])
  end
end
