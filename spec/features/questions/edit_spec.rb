require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As un author of question
  I'd like to be able to edit my question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  
  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)
    
    expect(page).to_not have_link 'Edit the Question'
  end
  
  describe 'Authenticated user', js: true do
    scenario 'edits his question' do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit the Question'

        fill_in 'Edit question\'s title', with: attributes_for(:question, :another)[:title]
        fill_in 'Edit question\'s body', with: attributes_for(:question, :another)[:body]

        click_on 'Update'

        wait_for_ajax
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content attributes_for(:question, :another)[:body]
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit the Question'

        fill_in 'Edit question\'s title', with: nil
        fill_in 'Edit question\'s body', with: nil

        click_on 'Update'
        
        wait_for_ajax
        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_content 'Title can\'t be blank'
        expect(page).to have_content 'Body can\'t be blank'
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'tries to edit another user\'s question' do
      sign_in(another_user)
      visit question_path(question)

      within '.question' do
        wait_for_ajax
        expect(page).to_not have_content 'Edit the Question'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_content 'Edit an Answer'
      expect(page).to_not have_selector 'textarea'
    end
  end
end
