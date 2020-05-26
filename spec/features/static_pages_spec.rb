require 'rails_helper'

RSpec.feature 'StaticPages', type: :feature do
  @base_title = 'RubyGram'

  scenario 'home page' do
    visit root_path
    expect(page).to have_http_status(200)
    expect(page).to have_title(@base_title)
  end

  scenario 'help page' do
    visit help_path
    expect(page).to have_http_status(200)
    expect(page).to have_title("Help | #{@base_title}")
  end

  scenario 'about page' do
    visit about_path
    expect(page).to have_http_status(200)
    expect(page).to have_title("About | #{@base_title}")
  end

  scenario 'contact page' do
    visit contact_path
    expect(page).to have_http_status(200)
    expect(page).to have_title("Contact | #{@base_title}")
  end
end
