include ActionDispatch::TestProcess
FactoryBot.define do
  factory :post do
    association :user
    description { Faker::Lorem.sentence(word_count: 5) }

    trait :with_image do
      image { fixture_file_upload(Rails.root.join('spec', 'support', 'fixtures', 'pixel.png'), 'image/png') }
    end
  end
end
