require 'rails_helper'

RSpec.describe QuestionsIndexChannel, type: :channel do
  it "subscribes to a stream" do
    subscribe
    perform('questions_index_follow')
    expect(subscription).to be_confirmed
    expect(subscription.streams).to include("questions_index")
  end
end
