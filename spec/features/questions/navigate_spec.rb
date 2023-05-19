require 'rails_helper'

feature 'User can move from viewing questions list to view current question and vice versa', %q{
  In order to read questions and current question details
  As an any user
  I'd like to be able to navigate from questions list to current question and vice versa
} do
  given!(:question) { create(:question) }
  given!(:another_question) { create(:question, :another) }
  
  scenario 'Any user tries to navigate from questions list to current question' do
    visit questions_path

    find("a[href='#{question_path(question)}']").click

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).not_to have_content another_question.title
    expect(page).not_to have_content another_question.body
  end

  scenario 'Any user tries to navigate from current question to questions list' do
    visit question_path(question)

    click_on 'Back'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content another_question.title
    expect(page).to have_content another_question.body
  end
end
