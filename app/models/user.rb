class User < ApplicationRecord
  has_many :bank_accounts

  validates :cpf, presence: true, uniqueness: true
  validate :valid_cpf_format
  validates :name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
