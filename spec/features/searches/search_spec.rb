require 'sphinx_helper'

feature 'User can search for questions, answers, comments and another users', %q{
  In order to find needed question, answer, comment or another user
  As an any user
  I'd like to be able to search for the question, answer, comment or another user
} do
  given(:user) { create(:user, email: 'some_user@test.com') }
  given(:question) { create(:question, title: 'question with some_query string in title') }
  given(:question_author) { create(:question, title: 'some_query', user: user) }
  given(:question_body) { create(:question, body: 'question with some_query string in body') }
  given(:answer) { create(:answer, body: 'answer with some_query string in body') }
  given(:comment) { create(:comment, body: 'comment with some_query string in body') }

  describe "Any user searches for the question in questions titles" , sphinx: true, js: true do
    scenario 'without specific author' do
      question
      visit searches_index_path

      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'some_query'
        click_on 'Find'

        within '.search-results' do
          wait_for_ajax
          expect(page).to have_content 'Question'
          expect(page).to have_content 'some_query'
        end
      end
    end

    scenario 'with specific author' do
      question_author
      visit searches_index_path

      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'some_query'
        fill_in 'author', with: 'some_user'
        click_on 'Find'

        within '.search-results' do
          wait_for_ajax
          expect(page).to have_content 'Question'
          expect(page).to have_content 'some_query'
          expect(page).to have_content 'some_user'
        end
      end
    end

    scenario 'with errors in title' do
      question
      visit searches_index_path

      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'wrong_query'
        click_on 'Find'

        within '.search-results' do
          wait_for_ajax
          expect(page).not_to have_content 'some_query'
          expect(page).to have_content "No result's found"
        end
      end
    end

    scenario 'with errors in author' do
      question
      visit searches_index_path

      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'some_query'
        fill_in 'author', with: 'wrong_user'
        click_on 'Find'

        within '.search-results' do
          wait_for_ajax
          expect(page).not_to have_content 'some_user'
          expect(page).to have_content "No result's found"
        end
      end
    end

    scenario 'with not enough characters in title' do
      question
      visit searches_index_path

      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'ab'
        click_on 'Find'

        within '.search-results' do
          wait_for_ajax
          expect(page).not_to have_content 'some_query'
          expect(page).to have_content "Minimum search queue: 3 symbols"
        end
      end
    end

    scenario 'with not enough characters in user' do
      question
      visit searches_index_path

      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'some_query'
        fill_in 'author', with: 'ab'
        click_on 'Find'

        within '.search-results' do
          wait_for_ajax
          expect(page).not_to have_content 'some_user'
          expect(page).to have_content "Minimum search queue: 3 symbols"
        end
      end
    end
  end

  scenario "Any user searches for the question in questions bodies" , sphinx: true, js: true do
    question_body
    visit searches_index_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'some_query'
      click_on 'Find'

      within '.search-results' do
        wait_for_ajax
        expect(page).to have_content 'Question'
        expect(page).to have_content 'some_query'
      end
    end
  end

  scenario "Any user searches for the answer" , sphinx: true, js: true do
    answer
    visit searches_index_path

    ThinkingSphinx::Test.run do
      uncheck 'Questions'
      check 'Answers'
      fill_in 'query', with: 'some_query'
      click_on 'Find'

      within '.search-results' do
        wait_for_ajax
        expect(page).to have_content 'Answer'
        expect(page).to have_content 'some_query'
      end
    end
  end

  scenario "Any user searches for the comment" , sphinx: true, js: true do
    comment
    visit searches_index_path

    ThinkingSphinx::Test.run do
      uncheck 'Questions'
      check 'Comments'
      fill_in 'query', with: 'some_query'
      click_on 'Find'

      within '.search-results' do
        wait_for_ajax
        expect(page).to have_content 'Comment'
        expect(page).to have_content 'some_query'
      end
    end
  end

  scenario "Any user searches for another user" , sphinx: true, js: true do
    user
    visit searches_index_path

    ThinkingSphinx::Test.run do
      uncheck 'Questions'
      check 'Users'
      fill_in 'query', with: 'some_user'
      click_on 'Find'

      within '.search-results' do
        wait_for_ajax
        expect(page).to have_content 'User'
        expect(page).to have_content 'some_user'
      end
    end
  end

  scenario "Any user searches for question, answer, comment and user in one time" , sphinx: true, js: true do
    create(:user, email: 'some_query@test.com')
    question
    answer
    comment
    visit searches_index_path

    ThinkingSphinx::Test.run do
      check 'Answers'
      check 'Comments'
      check 'Users'
      fill_in 'query', with: 'some_query'
      click_on 'Find'

      within '.search-results' do
        wait_for_ajax
        expect(page).to have_content 'Question'
        expect(page).to have_content 'Answer'
        expect(page).to have_content 'Comment'
        expect(page).to have_content 'User'
        expect(page).to have_content 'some_query'
      end
    end
  end
end
