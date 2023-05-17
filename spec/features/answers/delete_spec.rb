require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to delete a wrong (incorrect) answer
  As an authenticated user
  I'd like to be able to delete a answer
} do
  given(:user) { create(:user) }
  given(:question) { user.questions.create(attributes_for(:question)) }
  given!(:answer) { question.answers.create(attributes_for(:answer).merge!(user: user)) }

  scenario 'Authenticated user tries to delete a answer' do
    sign_in(user)
    visit question_path(question)

    find("a[href='#{answer_path(answer)}']").click

    expect(page).to have_content question[:title]
    expect(page).to have_content question[:body]
    expect(page).not_to have_content answer[:body]
  end

  scenario 'Unauthenticated user tries to delete a answer' do
    visit question_path(question)

    find("a[href='#{answer_path(answer)}']").click

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
