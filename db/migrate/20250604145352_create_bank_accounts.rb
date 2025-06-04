class CreateBankAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :bank_number, null: false
      t.string :bank_agency_number, null: false
      t.decimal :balance, precision: 15, scale: 2, default: 0.0, null: false

      t.timestamps
    end

    add_index :bank_accounts, :bank_number, unique: true
  end

  def down
    drop_table :bank_accounts
  end
end
