require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to delete a wrong (incorrect) answer
  As an authenticated user
  I'd like to be able to delete a answer
} do
  given(:users) { create_list(:user, 2) }
  given(:question) { users[0].questions.create(attributes_for(:question)) }
  given!(:answer) { question.answers.create(attributes_for(:answer).merge!(user: users[0])) }

  scenario 'Authenticated user tries to delete his answer' do
    sign_in(users[0])
    visit question_path(question)

    find("a[href='#{answer_path(answer)}']").click

    expect(page).to have_content question[:title]
    expect(page).to have_content question[:body]
    expect(page).not_to have_content answer[:body]
  end

  scenario 'Authenticated user tries to delete not his answer' do
    sign_in(users[1])
    visit question_path(question)

    expect(page).not_to have_content 'Delete an Answer'
  end

  scenario 'Unauthenticated user tries to delete a answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete an Answer'
  end
end
