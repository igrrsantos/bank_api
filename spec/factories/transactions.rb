FactoryBot.define do
  factory :transaction do
    association :origin_account, factory: :bank_account
    association :destination_account, factory: :bank_account
    amount { Faker::Number.between(from: 1.0, round: 2) } # Valor mínimo de 1.00
    description { Faker::Lorem.sentence(word_count: 3) }
    transaction_date { Faker::Time.between(from: 1.year.ago, to: Time.current) }

    trait :with_large_amount do
      amount { Faker::Number.between(from: 10_000.0, to: 100_000.0) }
    end

    trait :with_small_amount do
      amount { Faker::Number.between(from: 0.01, to: 10.0) }
    end

    trait :future_transaction do
      transaction_date { Faker::Time.forward(days: 30) }
    end

    trait :past_transaction do
      transaction_date { Faker::Time.backward(days: 365) }
    end

    trait :with_specific_date do
      transaction_date { DateTime.new(2023, 6, 15, 14, 30) }
    end

    trait :with_different_accounts do
      origin_account { create(:bank_account) }
      destination_account { create(:bank_account) }
    end

    trait :with_same_account do
      destination_account { origin_account }
    end
  end
end