class CreateTransactions < ActiveRecord::Migration[7.1]
  def up
    create_table :transactions do |t|
      t.references :origin_account, null: false, foreign_key: { to_table: :bank_accounts }
      t.references :destination_account, null: false, foreign_key: { to_table: :bank_accounts }
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :description
      t.datetime :transaction_date, null: false

      t.timestamps
    end

    add_index :transactions, :transaction_date
  end

  def down
    drop_table :transactions
  end
end
