require 'rails_helper'

feature 'User can watch all questions', %q{
  In order to read questions
  As an any user
  I'd like to be able to watch all questions
} do
  given!(:questions) do
    create(:question)
    create(:question, :another)
    create(:question, :another_one)
  end
  
  scenario 'Any user tries to watch all questions' do
    visit questions_path

    Question.all.each do |question|
      expect(page).to have_content question[:title]
    end
  end
end
