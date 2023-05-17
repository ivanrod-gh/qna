require 'rails_helper'

feature 'User can create answer', %q{
  In order to answering communities questions
  As an authenticated user
  I'd like to be able to publicate a question's answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      click_on 'Publicate an Answer'
    end

    scenario 'create an answer for question' do
      fill_in 'Body', with: attributes_for(:answer)[:body]

      click_on 'Answer'

      expect(page).to have_content attributes_for(:answer)[:body]
    end

    scenario 'create an answer for question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
     end
  end

  scenario 'Unauthenticated user tries to create an answer' do
      visit question_path(question)
      click_on 'Publicate an Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
