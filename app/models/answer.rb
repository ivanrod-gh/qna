# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  default_scope { order(id: :asc) }

  validates :body, presence: true

  after_create :send_notification

  private

  def send_notification
    Subscription.where(question: question).find_each(batch_size: 500) do |subscription|
      SubscriptionJob.perform_later(subscription.user, question) if question.answers.last.user != subscription.user
    end
  end
end
