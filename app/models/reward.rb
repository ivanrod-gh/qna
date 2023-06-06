# frozen_string_literal: true

class Reward < ApplicationRecord
  MINIMUM_REWARD_NAME_LENGTH = 5

  belongs_to :rewardable, polymorphic: true
  has_one :reward_achievement, dependent: :destroy

  has_one_attached :file

  validates :name, :file, presence: true
  validate :validate_reward_name, :validate_reward_content_type

  private

  def validate_reward_name
    return unless name && name.length < MINIMUM_REWARD_NAME_LENGTH

    errors.add(:name, "too short (minimum - #{MINIMUM_REWARD_NAME_LENGTH})")
  end

  def validate_reward_content_type
    errors.add(:content, "type is bad (allowed image only)") if file && file.content_type !~ /\Aimage/
  end
end
