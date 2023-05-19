require 'rails_helper'

feature 'User can watch question with answers', %q{
  In order to read questions and community answers
  As an any user
  I'd like to be able to watch questions and it's answers
} do
  given(:question) { create(:question) }
  given!(:answers) do
    create(:answer, question: question)
    create(:answer, :another, question: question)
    create(:answer, :another_one, question: question)
  end
  
  scenario 'Any user tries to watch question and it\'s answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    Answer.all.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
