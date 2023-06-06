require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :rewardable }
  it { should have_one(:reward_achievement).dependent(:destroy) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :file }

  it 'have one attached file' do
    expect(Reward.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
