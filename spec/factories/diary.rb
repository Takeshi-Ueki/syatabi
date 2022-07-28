FactoryBot.define do
  factory :diary do
    title { Faker::Lorem.characters(number: 10) }
    body { Faker::Lorem.characters(number: 500) }
    user
    post
  end
end
