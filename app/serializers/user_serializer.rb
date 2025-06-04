class UserSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :bank_accounts
end