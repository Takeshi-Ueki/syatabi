FactoryBot.define do
  factory :report do
    reporter_id { FactoryBot.create(:user).id }
    reported_id { FactoryBot.create(:user).id }
    reason { Faker::Lorem.characters(number: 20) }
  end
end
