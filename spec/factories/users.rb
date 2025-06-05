FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    cpf { CPF.generate(true) }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :with_bank_accounts do
      after(:create) do |user|
        create_list(:bank_account, 2, user: user)
      end
    end
  end
end
