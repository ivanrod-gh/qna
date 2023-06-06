require 'rails_helper'

feature 'User can view all his received rewards', %q{
  In order to see the importance of my work
  As an authenticated user
  I'd like to be able to see all my rewards
} do
  given(:user) { create(:user) }
  given(:reward_achievement) { create(:reward_achievement, user: user) }
 
  scenario 'Authenticated user tries to watch his rewards' do
    reward_achievement

    sign_in(user)

    click_on 'My Rewards'

    expect(page).to have_content 'BasicQuestionTitleString'
    expect(page).to have_content 'BasicRewardNameString'
    expect(find('.reward-image')['src']).to have_content 'reward1.png'
  end

  scenario 'Unauthenticated user tries to watch rewards' do
    visit(questions_path)

    expect(page).not_to have_content 'My Rewards'
  end
end
