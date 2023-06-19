require 'rails_helper'

feature 'User can delete his questions attached link', %q{
  In order to delete my unnecessary (expired) question's attached link
  As an authenticated user
  I'd like to be able to delete my question's attached link
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question_with_two_attached_links) { create(:question, :with_two_attached_links, user: user) }

  describe 'Authenticated user tries to delete one of his question\'s attached links', js: true do
    background do
      sign_in(user)

      visit question_path(question_with_two_attached_links)
    end

    scenario 'without editing the question' do
      within '.question' do
        find("a[href='#{link_path(question_with_two_attached_links.links.last)}']").click

        wait_for_ajax
        expect(page).to have_link href: 'https://ya.ru/'
        expect(page).not_to have_link href: 'https://2ip.ru/'
      end
    end

    scenario 'then edit the question' do
      within '.question' do
        click_on 'Edit the Question'

        all('.remove_fields.existing').first.click

        click_on 'Update'

        wait_for_ajax
        sleep(0.2)
        expect(page).to have_link href: 'https://ya.ru/'
        expect(page).not_to have_link href: 'https://2ip.ru/'
      end
    end
  end

  scenario 'Authenticated user tries to delete not his question\'s attached link' do
    sign_in(another_user)
    visit question_path(question_with_two_attached_links)

    within '.question' do
      expect(page).not_to have_link href: "#{link_path(question_with_two_attached_links.links.first)}"
      expect(page).not_to have_link href: "#{link_path(question_with_two_attached_links.links.last)}"
      expect(page).not_to have_content 'Edit the Question'
    end
  end

  scenario 'Unauthenticated user tries to delete a question\'s attached link' do
    visit question_path(question_with_two_attached_links)

    within '.question' do
      expect(page).not_to have_link href: "#{link_path(question_with_two_attached_links.links.first)}"
      expect(page).not_to have_link href: "#{link_path(question_with_two_attached_links.links.last)}"
      expect(page).not_to have_content 'Edit the Question'
    end
  end
end
