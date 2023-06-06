require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #rewards' do
    before { login(user) }
    before { get :rewards, params: { id: user } }

    it 'assign the requested achievements to @reward_achievements' do
      expect(assigns(:reward_achievements)).to eq user.reward_achievements
    end

    it 'render rewards view' do
      expect(response).to render_template :rewards
    end
  end
end
