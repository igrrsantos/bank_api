class Transaction < ApplicationRecord
  belongs_to :origin_account, class_name: 'BankAccount'
  belongs_to :destination_account, class_name: 'BankAccount'

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_date, presence: true
  validates :description, length: { maximum: 255 }

  validate :different_accounts

  private

  def different_accounts
    if origin_account_id == destination_account_id
      errors.add(:base, 'Origin and destination accounts must be different')
    end
  end
end
