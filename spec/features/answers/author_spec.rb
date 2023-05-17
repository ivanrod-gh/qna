require 'rails_helper'

feature 'User can be an author of an answer', %q{
  In order to have visual link between my answer and me
  As an any user
  I'd like to be an author of an answer
} do
  given(:users) { create_list(:user, 2) }
  given(:question) { users[0].questions.create(attributes_for(:question)) }
  given!(:answer) { question.answers.create(attributes_for(:answer).merge!(user: users[1])) }

  scenario 'Any user checks his authoring of an answer' do
    visit question_path(question)

    expect(page).to have_content "By: #{users[1].email}"
  end
end
