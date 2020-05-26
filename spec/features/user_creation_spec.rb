require 'rails_helper'

RSpec.feature 'UserCreations', type: :feature do
  scenario 'with valid email and password' do
    @user1 = FactoryBot.build(:user)
    visit new_user_registration_path
    fill_in 'Name', with: @user1.name
    fill_in 'Email', with: @user1.email
    fill_in 'Password', with: @user1.password
    fill_in 'Password confirmation', with: @user1.password
    click_button 'Create account'
    expect(page).to have_selector('.alert', text: 'Welcome to the RubyGram!')
    expect(page).to have_link('Log out')
    expect(page).to have_selector('.user_info', text: @user1.name)
    expect(page).to have_current_path(user_path(User.last.id))
  end

  scenario 'with invalid email and password' do
    @user1 = FactoryBot.build(:user, :invalid)
    visit new_user_registration_path
    fill_in 'Name', with: @user1.name
    fill_in 'Email', with: @user1.email
    fill_in 'Password', with: @user1.password
    fill_in 'Password confirmation', with: @user1.password
    click_button 'Create account'
    expect(page).to have_selector('.alert-danger')
    expect(page).not_to have_link('Log out')
    expect(page).to have_current_path('/users')
  end
end
