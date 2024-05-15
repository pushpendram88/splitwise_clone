FactoryBot.define do
  factory :settle_expense do
    amount { Faker::Number.decimal(l_digits: 2) }
    additional_note { Faker::Lorem.sentence }
    association :settle_by_id, factory: :user
    association :settle_to_id, factory: :user
  end
end