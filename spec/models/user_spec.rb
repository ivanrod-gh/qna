require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:reward_achievements).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'subscribed?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:subscription) { create(:subscription, user: user, question: question) }
    
    it 'return true if user subscribed to specific question' do
      subscription
      expect(user.subscribed?(question)).to eq true
    end
    
    it 'return false if user unsubscribed' do
      expect(user.subscribed?(question)).to eq false
    end
  end
end
