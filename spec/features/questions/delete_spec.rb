require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete an unnecessary (expired) question
  As an authenticated user
  I'd like to be able to delete a question
} do
  given(:user) { create(:user) }
  given!(:questions) do
    questions = []
    questions.push(create(:question))
    questions.push(create(:question, :another))
  end
  
  scenario 'Authenticated user tries to delete a question' do
    sign_in(user)
    visit question_path(questions[0])

    click_on 'Delete the Question'

    expect(page).not_to have_content questions[0][:title]
    expect(page).not_to have_content questions[0][:body]
    expect(page).to have_content questions[1][:title]
    expect(page).to have_content questions[1][:body]
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(questions[0])

    click_on 'Delete the Question'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
