FactoryBot.define do
  factory :bank_account do
    association :user
    bank_number { Faker::Bank.unique.account_number(digits: 8) }
    bank_agency_number { Faker::Bank.unique.routing_number }
    balance { Faker::Number.decimal(l_digits: 3, r_digits: 2) }

    trait :with_zero_balance do
      balance { 0.00 }
    end

    trait :with_negative_balance do
      balance { -100.00 }
    end

    trait :with_large_balance do
      balance { 1_000_000.00 }
    end

    trait :with_specific_bank_number do
      sequence(:bank_number) { |n| "12345#{format('%03d', n)}" }
    end
  end
end