require 'rails_helper'

feature 'User can create answer at question page', %q{
  In order to comfortable answering communities questions
  As an authenticated user
  I'd like to be able to publicate a question's answer at question's page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'create an answer for question' do
      fill_in 'Body', with: attributes_for(:answer)[:body]

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_content attributes_for(:answer)[:body]
      end
    end

    scenario 'create an answer for question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
     end
  end

  scenario 'Unauthenticated user tries to create an answer' do
    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
