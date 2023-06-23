require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Test question body'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question title'
      expect(page).to have_content 'Test question body'
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Test question body'

      attach_file 'Files', ["#{Rails.root}/spec/files/file1.txt", "#{Rails.root}/spec/files/file2.txt"]
      
      click_on 'Ask'

      expect(page).to have_link 'file1.txt'
      expect(page).to have_link 'file2.txt'
    end

    scenario 'asks a question with attached reward' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Test question body'

      fill_in 'Reward name', with: 'Test reward name'
      attach_file 'File', "#{Rails.root}/spec/files/reward1.png"
      
      click_on 'Ask'

      expect(page).to have_link 'Test reward name'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'When multiple users exists', js: true do
    scenario 'any user can see question immediately appears when another user creates it' do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end
      
      Capybara.using_session('guest') do
        visit questions_path
      end
      
      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Test question title'
        fill_in 'Body', with: 'Test question body'
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question title'
        expect(page).to have_content 'Test question body'
      end
      
      Capybara.using_session('guest') do
        wait_for_ajax
        expect(page).to have_content 'Test question title'
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path

    expect(page).to have_content 'In order to ask questions please sign in'
  end
end
