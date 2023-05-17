require 'rails_helper'

feature 'User can watch question with answers', %q{
  In order to read questions and community answers
  As an any user
  I'd like to be able to watch questions and it's answers
} do
  given(:user) { create(:user) }
  given(:question) { user.questions.create(attributes_for(:question)) }
  given!(:answers) do
    question.answers.create(attributes_for(:answer).merge!(user: user))
    question.answers.create(attributes_for(:answer, :another).merge!(user: user))
    question.answers.create(attributes_for(:answer, :yet_another).merge!(user: user))
    question.answers
  end
  
  scenario 'Any user tries to watch question and it\'s answers' do
    visit question_path(question)

    expect(page).to have_content question[:title]
    expect(page).to have_content question[:body]
    answers.each do |answer|
      expect(page).to have_content answer[:body]
    end
  end
end
