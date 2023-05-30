require 'rails_helper'

feature 'User can delete his answers attached file', %q{
  In order to delete an unnecessary (expired) answers's attached file
  As an authenticated user
  I'd like to be able to delete my answers's attached file
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer_with_two_attaches) { create(:answer, :with_two_attaches, user: user, question: question) }

  scenario 'Authenticated user tries to delete one of his answer\'s attached files', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      find("a[href='#{attachment_path(answer_with_two_attaches.files.last)}']").click

      wait_for_ajax
      expect(page).to have_content 'file1.txt'
      expect(page).not_to have_content 'file2.txt'
    end
  end

  scenario 'Authenticated user tries to delete not his answer\'s attached file' do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content 'Delete attached file'
    end
  end

  scenario 'Unauthenticated user tries to delete a answer\'s attached file' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content 'Delete attached file'
    end
  end
end
