require 'rails_helper'

feature 'User can add comment to an answer', %q{
  In order to commentate an answer
  As an authenticated user
  I'd like to be able to add comment to an answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  
  describe 'Authenticated user tries', js: true do
    scenario 'to comments an answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        fill_in 'Add comment', with: 'Comment text'

        click_on 'Comment'

        wait_for_ajax
        expect(page).to have_content 'Comment text'
      end
    end

    scenario 'to comments an answer with errors' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Comment'

        wait_for_ajax
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'When multiple users exists and they watch the answers\'s question', js: true do
    scenario 'any user can see comment immediately appears when another user creates it' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      
      Capybara.using_session('guest') do
        visit question_path(question)
      end
      
      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Add comment', with: 'Comment text'

          click_on 'Comment'

          wait_for_ajax
          expect(page).to have_content 'Comment text'
        end
      end
      
      Capybara.using_session('guest') do
        within '.answers' do
          wait_for_ajax
          expect(page).to have_content 'Comment text'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to comments an answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Add comment'
  end
end
