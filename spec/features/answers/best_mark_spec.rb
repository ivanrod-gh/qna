require 'rails_helper'

feature 'User can mark an answer for his question as the best answer', %q{
  In order to mark my question as resolved
  As an authenticated user
  I'd like to be able to mark an answer for my question as the best answer
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user', js: true do
    scenario 'tries to mark an answer for his question as the best answer' do
      sign_in(user)
      visit question_path(question)

      click_on 'Mark as best'

      wait_for_ajax
      expect(page).to have_content '*Best answer*'
    end

    scenario 'tries to mark an answer for not his question as the best answer' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).not_to have_content 'Mark as best'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to mark an answer as the best answer' do
      visit question_path(question)

      expect(page).not_to have_content 'Mark as best'
    end
  end
  
end
