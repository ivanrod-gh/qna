# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validate :validate_url

  def gist?
    url =~ /\Ahttps:\/\/gist.github.com/ ? true : false
  end

  def gist_id
    url.split('/').reverse_each do |id|
      return id if id
    end
  end

  private

  def validate_url
    errors.add(:url, "is invalid") unless url =~ /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
  end
end
