# Admin user creation .
User.create!(name: 'Admin User',
             email: 'admin.user@mail.org',
             password: '123123123',
             password_confirmation: '123123123',
             admin: true)

# Usual user creation.
User.create!(name: 'Test User',
             email: 'test.user@mail.org',
             password: '123123123',
             password_confirmation: '123123123')

# Generate a bunch of additional users.
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@mail.org"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
