require 'rails_helper'

feature 'User can delete his questions attached file', %q{
  In order to delete an unnecessary (expired) question's attached file
  As an authenticated user
  I'd like to be able to delete my question's attached file
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question_with_two_attaches) { create(:question, :with_two_attaches, user: user) }

  scenario 'Authenticated user tries to delete one of his question\'s attached files', js: true do
    sign_in(user)
    visit question_path(question_with_two_attaches)

    within '.question' do
      find("a[href='#{attachment_path(question_with_two_attaches.files.last)}']").click

      wait_for_ajax
      expect(page).to have_content 'file1.txt'
      expect(page).not_to have_content 'file2.txt'
    end
  end

  scenario 'Authenticated user tries to delete not his question\'s attached file' do
    sign_in(another_user)
    visit question_path(question_with_two_attaches)

    within '.question' do
      expect(page).not_to have_content 'Delete attached file'
    end
  end

  scenario 'Unauthenticated user tries to delete a question\'s attached file' do
    visit question_path(question_with_two_attaches)

    within '.question' do
      expect(page).not_to have_content 'Delete attached file'
    end
  end
end
