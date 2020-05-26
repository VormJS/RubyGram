FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password' }

    trait :admin do
      admin { true }
    end

    trait :invalid do
      email { 'not_valid' }
      password { 'too bad' }
    end
  end
end
