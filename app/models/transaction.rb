class Transaction < ApplicationRecord
  belongs_to :origin_account, class_name: 'ContaBancaria'
  belongs_to :destination_account, class_name: 'ContaBancaria'

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_date, presence: true
  validates :description, length: { maximum: 255 }
end
