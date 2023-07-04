require 'rails_helper'

RSpec.describe Services::Subscription do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question) }
  
  it "sends notification to all question's subscribed users" do
    users.each do |user|
      expect(SubscriptionMailer).to receive(:notify).with(user, question).and_call_original
      subject.send_notify(user, question)
    end
  end
end
