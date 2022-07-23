FactoryBot.define do
  factory :post do
    body { Faker::Lorem.characters(number: 20) }
    user
    after(:build) do |post|
      post.images.attach(io: File.open('spec/fixtures/test_image.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
    end
  end
end