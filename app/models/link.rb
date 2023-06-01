# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validate :validate_url

  private

  def validate_url
    errors.add(:url, "is invalid") unless url =~ /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
  end
end
