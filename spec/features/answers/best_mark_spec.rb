require 'rails_helper'

feature 'User can mark an answer for his question as the best answer', %q{
  In order to mark my question as resolved
  As an authenticated user
  I'd like to be able to mark an answer for my question as the best answer
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question_with_attached_reward) { create(:question, :with_attached_reward, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:another_answer) { create(:answer, user: user, question: question_with_attached_reward) }

  describe 'Authenticated user', js: true do
    describe 'tries to mark an answer for his question as the best answer' do
      scenario 'then question does not has a reward' do
        answer
        sign_in(user)
        visit question_path(question)

        click_on 'Mark as best'

        within '.answers' do
          wait_for_ajax
          expect(page).to have_content '*Best answer*'
        end
      end

      scenario 'then question has a reward' do
        another_answer
        sign_in(user)
        visit question_path(question_with_attached_reward)

        click_on 'Mark as best'

        within '.answers' do
          wait_for_ajax
          expect(page).to have_content 'BasicRewardString'
        end
      end
    end

    scenario 'tries to mark an answer for not his question as the best answer' do
      answer
      sign_in(another_user)
      visit question_path(question)

      expect(page).not_to have_content 'Mark as best'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to mark an answer as the best answer' do
      answer
      visit question_path(question)

      expect(page).not_to have_content 'Mark as best'
    end
  end
end
