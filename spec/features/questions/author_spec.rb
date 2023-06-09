require 'rails_helper'

feature 'User can be an author of the question', %q{
  In order to have visual link between my question and me
  As an any user
  I'd like to be an author of the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Any user checks his authoring of the question' do
    visit question_path(question)

    expect(page).to have_content "By: #{user.email}"
  end
end
