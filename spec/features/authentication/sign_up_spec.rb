require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to enter my details data then sign in
} do
  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: attributes_for(:user)[:email]
    fill_in 'Password', with: attributes_for(:user)[:password]
    fill_in 'Password confirmation', with: attributes_for(:user)[:password]
    click_on 'Register'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with errors' do
    click_on 'Register'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
