require 'rails_helper'

feature 'User can delete his answers attached comment', %q{
  In order to delete my unnecessary (expired) answer's attached comment
  As an authenticated user
  I'd like to be able to delete my answer's attached comment
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, user: user, commentable: answer) }

  scenario 'Authenticated user tries to delete his answer\'s attached comment', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      find("a[href='#{comment_path(comment)}']").click

      wait_for_ajax
      expect(page).not_to have_content attributes_for(:comment)
    end
  end

  describe 'When multiple users exists and they watch the answer\'s question', js: true do
    scenario 'any user can see comment immediately disappears when another user destroy it' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      
      Capybara.using_session('guest') do
        visit question_path(question)
      end
      
      Capybara.using_session('user') do
        find("a[href='#{comment_path(comment)}']").click

        wait_for_ajax
        expect(page).not_to have_content attributes_for(:comment)
      end
      
      Capybara.using_session('guest') do
        wait_for_ajax
        expect(page).not_to have_content attributes_for(:comment)
      end
    end
  end

  scenario 'Authenticated user tries to delete not his answer\'s attached comment' do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link href: "#{comment_path(comment)}"
    end
  end

  scenario 'Unauthenticated user tries to delete an answer\'s attached comment' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link href: "#{comment_path(comment)}"
    end
  end
end
