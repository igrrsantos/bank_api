class BankAccount < ApplicationRecord
  belongs_to :user

  validates :bank_number, presence: true, uniqueness: true
  validates :bank_agency_number, presence: true
  validates :balance, presence: true, numericality: true

  scope :positive_balance, -> { where('balance > 0') }
  scope :negative_balance, -> { where('balance < 0') }
end
