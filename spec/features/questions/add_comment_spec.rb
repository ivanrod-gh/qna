require 'rails_helper'

feature 'User can add comment to the question', %q{
  In order to commentate the question
  As an authenticated user
  I'd like to be able to add comment to this question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  describe 'Authenticated user tries to', js: true do
    scenario 'comments the question' do
      sign_in(user)
      visit question_path(question)

      fill_in 'Add comment', with: 'Comment text'

      click_on 'Comment'

      wait_for_ajax
      expect(page).to have_content 'Comment text'
    end

    scenario 'comments the question with errors' do
      sign_in(user)
      visit question_path(question)

      click_on 'Comment'

      wait_for_ajax
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'When multiple users exists and they watch the question', js: true do
    scenario 'any user can see comment immediately appears when another user creates it' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      
      Capybara.using_session('guest') do
        visit question_path(question)
      end
      
      Capybara.using_session('user') do
        fill_in 'Add comment', with: 'Comment text'

        click_on 'Comment'

        wait_for_ajax
        expect(page).to have_content 'Comment text'
      end
      
      Capybara.using_session('guest') do
        wait_for_ajax
        expect(page).to have_content 'Comment text'
      end
    end
  end

  scenario 'Unauthenticated user tries to comments the question' do
    visit question_path(question)

    expect(page).not_to have_content 'Add comment'
  end
end
