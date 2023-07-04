require "rails_helper"

RSpec.describe SubscriptionMailer, type: :mailer do
  describe "notify" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:subscription) { create(:subscription, user: user, question: question) }
    let!(:answer) { create(:answer, question: question) }
    let(:mail) { SubscriptionMailer.notify(user, question) }

    it "renders the headers" do
      expect(mail.subject).to eq("QnA: subscription notify (#{question.title.truncate(100)})")
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("#{question.title.truncate(100)}")
      expect(mail.body.encoded).to match("#{answer.body.truncate(100)}")
    end
  end

end
