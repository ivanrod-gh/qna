require 'rails_helper'

feature 'User can vote for an answer', %q{
  In order to highlight an answer
  As an authenticated user
  I'd like to be able to like or dislike this answer
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:another_answer) { create(:answer, user: another_user, question: question) }

  describe 'Authenticated user' do
    describe 'as an author of the answer' do
      background do
        sign_in(user)
        answer
        visit question_path(question)
      end

      scenario 'tries to vote for his answer' do
        within '.answers' do
          expect(page).not_to have_content 'Like'
          expect(page).not_to have_content 'Dislike'
        end
      end
    end

    describe 'as not an author of the answer', js: true do
      background do
        sign_in(user)
        another_answer
        visit question_path(question)
      end

      scenario 'tries to like an answer' do
        within '.answers' do
          click_on 'Like'

          wait_for_ajax
          expect(page).to have_content '1'
        end
      end

      scenario 'tries to dislike an answer' do
        within '.answers' do
          click_on 'Dislike'

          wait_for_ajax
          expect(page).to have_content '-1'
        end
      end

      scenario 'tries delete his vote from answer by double liking' do
        within '.answers' do
          click_on 'Like'
          click_on 'Like'

          wait_for_ajax
          expect(page).to have_content '0'
        end
      end

      scenario 'tries delete his vote from answer by double disliking' do
        within '.answers' do
          click_on 'Dislike'
          click_on 'Dislike'

          wait_for_ajax
          expect(page).to have_content '0'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content 'Like'
      expect(page).not_to have_content 'Dislike'
    end
  end
end
