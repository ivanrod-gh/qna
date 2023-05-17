require 'rails_helper'

feature 'User can move from viewing questions list to view current question and vice versa', %q{
  In order to read questions and current question details
  As an any user
  I'd like to be able to navigate from questions list to current question and vice versa
} do
  given!(:questions) do
    questions = []
    questions.push(create(:question))
    questions.push(create(:question, :another))
  end
  
  scenario 'Any user tries to navigate from questions list to current question' do
    visit questions_path
    find("a[href='#{question_path(questions[0])}']").click

    expect(page).to have_content questions[0][:title]
    expect(page).to have_content questions[0][:body]
    expect(page).not_to have_content questions[1][:title]
    expect(page).not_to have_content questions[1][:body]
  end

  scenario 'Any user tries to navigate from current question to questions list' do
    visit question_path(questions[0])

    click_on 'Back'

    expect(page).to have_content questions[0][:title]
    expect(page).to have_content questions[0][:body]
    expect(page).to have_content questions[1][:title]
    expect(page).to have_content questions[1][:body]
  end
end
