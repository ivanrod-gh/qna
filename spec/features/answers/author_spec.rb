require 'rails_helper'

feature 'User can be an author of an answer', %q{
  In order to have visual link between my answer and me
  As an any user
  I'd like to be an author of an answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Any user checks his authoring of an answer' do
    visit question_path(question)

    expect(page).to have_content "By: #{user.email}"
  end
end
