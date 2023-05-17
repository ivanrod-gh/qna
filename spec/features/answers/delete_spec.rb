require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to delete a wrong (incorrect) answer
  As an authenticated user
  I'd like to be able to delete a answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { question.answers.push(Answer.new(attributes_for(:answer))) }

  scenario 'Authenticated user tries to delete a answer' do
    sign_in(user)
    visit question_path(question)

    find("a[href='#{answer_path(answers[0])}']").click

    expect(page).to have_content question[:title]
    expect(page).to have_content question[:body]
    expect(page).not_to have_content answers[0][:body]
  end

  scenario 'Unauthenticated user tries to delete a answer' do
    visit question_path(question)

    find("a[href='#{answer_path(answers[0])}']").click

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
