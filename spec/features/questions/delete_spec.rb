require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete an unnecessary (expired) question
  As an authenticated user
  I'd like to be able to delete a question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:another_question) { create(:question, :another, user: another_user) }

  scenario 'Authenticated user tries to delete his question' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete the Question'

    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body
    expect(page).to have_content another_question.title
    expect(page).to have_content another_question.body
  end

  scenario 'Authenticated user tries to delete not his question' do
    sign_in(user)
    visit question_path(another_question)

    expect(page).not_to have_content 'Delete the Question'
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete the Question'
  end
end
