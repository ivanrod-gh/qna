require 'rails_helper'

feature 'User can add links to an answer', %q{
  In order to provide additional information for my answer
  As an author of the answer
  I'd like to be able to add links to my answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:repo_url) { 'https://github.com/ivanrod-gh/qna' }
  
  scenario 'Authenticated user answer the question with attaching a link to an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: attributes_for(:answer)[:body]

    fill_in 'Link name', with: 'My repo'
    fill_in 'Url', with: repo_url

    click_on 'Answer'

    within '.answers' do
      wait_for_ajax
      expect(page).to have_link 'My repo', href: repo_url
    end
  end
end
