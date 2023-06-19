require 'rails_helper'

RSpec.describe QuestionsShowChannel, type: :channel do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before do
    question
  end

  it "subscribes to a stream with number" do
    subscribe
    perform('questions_show_follow', question_id: question.id)
    expect(subscription).to be_confirmed
    expect(subscription.streams).to include("questions_#{question.id}_show")
  end
end
