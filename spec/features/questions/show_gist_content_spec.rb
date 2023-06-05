require 'rails_helper'

feature 'User can see gist content on questions page', %q{
  In order to see gist content without having to navigate to gist page 
  As an any user
  I'd like to be able see gist content right on the question's page
} do
  given(:question_with_attached_gist_link) { create(:question, :with_attached_gist_link) }

  scenario 'User tries to see question\'s gist content at question\'s page', js: true do
    visit question_path(question_with_attached_gist_link)
    
    click_on 'Show gist content (simplified)'

    wait_for_ajax
    expect(page).to have_content 'gistfile1.txt'
    expect(page).to have_content 'line0'
    expect(page).to have_content 'gistfile2.txt'
    expect(page).to have_content 'line2gf2'
  end
end
