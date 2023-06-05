require 'rails_helper'

feature 'User can see answers gist content on questions page', %q{
  In order to see gist content without having to navigate to gist page 
  As an any or authenticated user
  I'd like to be able see answer's gist content right on the question's page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer_with_attached_gist_link) { create(:answer, :with_attached_gist_link, user: user, question: question) }

  scenario 'User tries to see answer\'s gist content at question\'s page', js: true do
    answer_with_attached_gist_link

    visit question_path(question)
    
    click_on 'Show gist content (simplified)'

    wait_for_ajax
    expect(page).to have_content 'gistfile1.txt'
    expect(page).to have_content 'line0'
    expect(page).to have_content 'gistfile2.txt'
    expect(page).to have_content 'line2gf2'
  end

  scenario 'Authenticated user tries to create an answer with linked gist and see gist content of this answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: attributes_for(:answer)[:body]
    fill_in 'Link name', with: 'gist link'
    fill_in 'Url', with: 'https://gist.github.com/ivanrod-gh/da32151556476ce4cbebd5d0c0c2acbe'

    click_on 'Answer'
    
    click_on 'Show gist content (simplified)'

    wait_for_ajax
    expect(page).to have_content 'gistfile1.txt'
    expect(page).to have_content 'line0'
    expect(page).to have_content 'gistfile2.txt'
    expect(page).to have_content 'line2gf2'
  end
end
