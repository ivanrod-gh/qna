require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do
  background { visit new_user_session_path }

  given(:user) { create(:user) }

  describe 'Registered user' do
    before do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    scenario 'tries to sign in' do
      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'tries to sign in again' do
      visit new_user_session_path

      expect(page).to have_content 'You are already signed in.'
    end
  end
  
  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: '111'
    fill_in 'Password', with: '222'
    click_on 'Log in'
    
    expect(page).to have_content 'Invalid Email or password.'
  end
end
