require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As un author of answer
  I'd like to be able to edit my answer
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  
  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)
    
    expect(page).to_not have_link 'Edit'
  end
  
  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit an Answer'

        fill_in 'Edit your answer', with: attributes_for(:answer, :another)[:body]

        click_on 'Save'

        wait_for_ajax
        expect(page).to_not have_content answer.body
        expect(page).to have_content attributes_for(:answer, :another)[:body]
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit an Answer'

        fill_in 'Edit your answer', with: nil

        click_on 'Save'
        
        wait_for_ajax
        expect(page).to have_content answer.body
        expect(page).to have_content 'Body can\'t be blank'
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'tries to edit another user\'s question' do
      sign_in(another_user)
      visit question_path(question)

      within '.answers' do
        wait_for_ajax
        expect(page).to_not have_content 'Edit an Answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Unauthenticated user tries to edit question' do
      visit question_path(question)

      within '.answers' do
        wait_for_ajax
        expect(page).to_not have_content 'Edit an Answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
end
