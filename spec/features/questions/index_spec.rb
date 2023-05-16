require 'rails_helper'

feature 'User can watch all questions', %q{
  In order to read questions
  As an any user
  I'd like to be able to watch all questions
} do
  given!(:questions) do
    create(:question)
    create(:question, :another)
  end
  
  scenario 'Any user can watch all questions' do
    visit questions_path

    expect(page).to have_content attributes_for(:question)[:title]
    expect(page).to have_content attributes_for(:question)[:body]
    expect(page).to have_content attributes_for(:question, :another)[:title]
    expect(page).to have_content attributes_for(:question, :another)[:body]
  end
end
