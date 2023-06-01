require 'rails_helper'

feature 'User can add links to the question', %q{
  In order to provide additional information for my question
  As an author of the question
  I'd like to be able to add links to my question
} do
  given(:user) { create(:user) }
  given(:repo_url) { 'https://github.com/ivanrod-gh/qna' }
  
  scenario 'Authenticated user asks question with attaching a link to the question' do
    sign_in(user)
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test question body'

      
    fill_in 'Link name', with: 'My repo'
    fill_in 'Url', with: repo_url

    click_on 'Ask'

    expect(page).to have_link 'My repo', href: repo_url
  end
end
