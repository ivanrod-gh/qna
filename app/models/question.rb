# frozen_string_literal: true

class Question < ApplicationRecord
  MINIMUM_REWARD_NAME_LENGTH = 5

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files
  has_one_attached :reward

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validate :validate_reward_name
  validate :validate_reward_content_type

  def sorted_answers
    sotred_by_index = answers.order(id: :asc)
    if any_best?
      special_sorted = []
      sotred_by_index.each do |answer|
        answer.best? ? special_sorted.unshift(answer) : special_sorted.push(answer)
      end
      special_sorted
    else
      sotred_by_index
    end
  end

  private

  def validate_reward_name
    if (reward.present? && reward_name.length < MINIMUM_REWARD_NAME_LENGTH)
      errors.add(:base, "Reward name too short (minimum - #{MINIMUM_REWARD_NAME_LENGTH})")
    end
    errors.add(:base, "No reward selected") if reward.filename.nil? && reward_name.present?
  end

  def validate_reward_content_type
    errors.add(:base, "Bad content type (allowed image only)") if reward.present? && reward.content_type !~ /\Aimage/
  end

  def any_best?
    answers.each do |answer|
      return true if answer.best?
    end
    false
  end
end
