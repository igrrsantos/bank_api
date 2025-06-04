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

  def generate_jwt
    payload = {
      user_id: self.id,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end

  private

  def valid_cpf_format
    return if cpf.blank?

    unless CPF.valid?(cpf)
      errors.add(:cpf, 'não é válido')
    end
  end
end
