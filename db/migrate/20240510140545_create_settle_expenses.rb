class CreateSettleExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :settle_expenses do |t|
      t.integer :settle_by_id
      t.integer :settle_to_id
      t.float :amount
      t.text :additional_note

      t.timestamps
    end
  end
end
