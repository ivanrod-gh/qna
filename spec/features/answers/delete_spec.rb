require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to delete a wrong (incorrect) answer
  As an authenticated user
  I'd like to be able to delete a answer
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Authenticated user tries to delete his answer', js: true do
    sign_in(user)
    visit question_path(question)

    find("a[href='#{answer_path(answer)}']").click

    wait_for_ajax
    expect(page).to have_content question[:title]
    expect(page).to have_content question[:body]
    expect(page).not_to have_content answer[:body]
  end

  scenario 'Authenticated user tries to delete not his answer' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).not_to have_content 'Delete an Answer'
  end

  scenario 'Unauthenticated user tries to delete a answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete an Answer'
  end
end
