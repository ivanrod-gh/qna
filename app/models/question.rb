# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  has_many_attached :files

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
