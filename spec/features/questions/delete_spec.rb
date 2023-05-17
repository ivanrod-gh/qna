require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete an unnecessary (expired) question
  As an authenticated user
  I'd like to be able to delete a question
} do
  given(:users) { create_list(:user, 2) }
  given!(:questions) do
    users[0].questions.create(attributes_for(:question))
    users[0].questions.create(attributes_for(:question, :another))
    users[0].questions
  end

  scenario 'Authenticated user tries to delete his question' do
    sign_in(users[0])
    visit question_path(questions[0])

    click_on 'Delete the Question'

    expect(page).not_to have_content questions[0][:title]
    expect(page).not_to have_content questions[0][:body]
    expect(page).to have_content questions[1][:title]
    expect(page).to have_content questions[1][:body]
  end

  scenario 'Authenticated user tries to delete not his question' do
    sign_in(users[1])
    visit question_path(questions[0])

    expect(page).not_to have_content 'Delete the Question'
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(questions[0])

    expect(page).not_to have_content 'Delete the Question'
  end
end
