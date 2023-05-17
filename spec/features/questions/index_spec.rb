require 'rails_helper'

feature 'User can watch all questions', %q{
  In order to read questions
  As an any user
  I'd like to be able to watch all questions
} do
  given!(:questions) do
    questions = []
    questions.push(create(:question))
    questions.push(create(:question, :another))
    questions.push(create(:question, :yet_another))
  end
  
  scenario 'Any user tries to watch all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question[:title]
      expect(page).to have_content question[:body]
    end
  end
end
