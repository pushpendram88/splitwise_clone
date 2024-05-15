class AddTaxTipSubTotalToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :tax, :float, default: 0.0
    add_column :expenses, :tip, :float, default: 0.0
    add_column :expenses, :sub_total, :float, default: 0.0
  end
end
