require 'rails_helper'

feature 'User can watch all questions', %q{
  In order to read questions
  As an any user
  I'd like to be able to watch all questions
} do
  given(:user) { create(:user) }
  given!(:questions) do
    user.questions.create(attributes_for(:question))
    user.questions.create(attributes_for(:question, :another))
    user.questions.create(attributes_for(:question, :yet_another))
    user.questions
  end
  
  scenario 'Any user tries to watch all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question[:title]
      expect(page).to have_content question[:body]
    end
  end
end
