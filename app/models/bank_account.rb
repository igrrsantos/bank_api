class BankAccount < ApplicationRecord
  belongs_to :user

  validates :bank_number, presence: true, uniqueness: true
  validates :bank_agency_number, presence: true
  validates :balance, presence: true, numericality: true
end
