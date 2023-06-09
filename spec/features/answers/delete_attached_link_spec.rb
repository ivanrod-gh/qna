require 'rails_helper'

feature 'User can delete his answers attached link', %q{
  In order to delete my unnecessary (expired) answer's attached link
  As an authenticated user
  I'd like to be able to delete my answer's attached link
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer_with_two_attached_links) { create(:answer, :with_two_attached_links, user: user, question: question) }

  describe 'Authenticated user tries to delete one of his answer\'s attached links', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'without editing an answer' do
      within '.answers' do
        find("a[href='#{link_path(answer_with_two_attached_links.links.last)}']").click

        wait_for_ajax
        expect(page).to have_link href: 'https://ya.ru/'
        expect(page).not_to have_link href: 'https://2ip.ru/'
      end
    end

    scenario 'then edit an answer' do
      within '.answers' do
        click_on 'Edit an Answer'

        all('.remove_fields.existing').first.click

        click_on 'Save'

        wait_for_ajax
        sleep(0.2)
        expect(page).to have_link href: 'https://ya.ru/'
        expect(page).not_to have_link href: 'https://2ip.ru/'
      end
    end
  end

  scenario 'Authenticated user tries to delete not his answer\'s attached link' do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link href: "#{link_path(answer_with_two_attached_links.links.first)}"
      expect(page).not_to have_link href: "#{link_path(answer_with_two_attached_links.links.last)}"
      expect(page).not_to have_content 'Edit an Answer'
    end
  end

  scenario 'Unauthenticated user tries to delete a answer\'s attached link' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link href: "#{link_path(answer_with_two_attached_links.links.first)}"
      expect(page).not_to have_link href: "#{link_path(answer_with_two_attached_links.links.last)}"
      expect(page).not_to have_content 'Edit an Answer'
    end
  end
end
