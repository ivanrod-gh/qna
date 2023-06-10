require 'rails_helper'

feature 'User can vote for the question', %q{
  In order to highlight the question
  As an authenticated user
  I'd like to be able to like or dislike this question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question, user: another_user) }

  describe 'Authenticated user' do
    describe 'as an author of the question' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'tries to vote for his question' do
        expect(page).not_to have_content 'Like'
        expect(page).not_to have_content 'Dislike'
      end
    end

    describe 'as not an author of the question', js: true do
      background do
        sign_in(user)
        another_question
        visit question_path(another_question)
      end

      scenario 'tries to like an question' do
        click_on 'Like'

        wait_for_ajax
        expect(page).to have_content '1'
      end

      scenario 'tries to dislike an question' do
        click_on 'Dislike'

        wait_for_ajax
        expect(page).to have_content '-1'
      end

      scenario 'tries delete his vote from question by double liking' do
        click_on 'Like'
        click_on 'Like'

        wait_for_ajax
        expect(page).to have_content '0'
      end

      scenario 'tries delete his vote from question by double disliking' do
        click_on 'Dislike'
        click_on 'Dislike'

        wait_for_ajax
        expect(page).to have_content '0'
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for question' do
    visit question_path(question)

    expect(page).not_to have_content 'Like'
    expect(page).not_to have_content 'Dislike'
  end
end
