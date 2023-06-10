# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :votable
  has_one :reward, dependent: :destroy, as: :rewardable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

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

  def any_best?
    answers.each do |answer|
      return true if answer.best?
    end
    false
  end
end
