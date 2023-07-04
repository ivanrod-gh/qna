require 'rails_helper'

feature 'User can subscribe to question and unsubscribe from question', %q{
  In order to get fast answer to my question
  As an authenticated user
  I'd like to be able to subscribe to question or unsubscribe from him
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user tries to subscribe to question', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Subscribe to the Question'

    wait_for_ajax
    expect(page).to have_content 'Unsubscribe from the Question'
  end

  scenario 'Authenticated user tries to unsubscribe from question', js: true do
    Subscription.create(user: user, question: question)
    sign_in(user)
    visit question_path(question)

    click_on 'Unsubscribe from the Question'

    wait_for_ajax
    expect(page).to have_content 'Subscribe to the Question'
  end

  scenario 'Unauthenticated user tries to subscribe or unsubscribe from question' do
    visit question_path(question)

    expect(page).not_to have_content 'Subscribe to the Question'
    expect(page).not_to have_content 'Unsubscribe from the Question'
  end
end
