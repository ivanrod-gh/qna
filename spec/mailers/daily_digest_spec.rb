require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("QnA: daily digest of questions")
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(["from@example.com"])
    end

    describe 'then new questions asked' do
      let!(:question) { create(:question) }
      let!(:another_question) { create(:question, :another) }

      it "renders the body" do
        expect(mail.body.encoded).to match("New questions asked in the last 24 hours")
        expect(mail.body.encoded).to match("#{question.title.truncate(100)}")
        expect(mail.body.encoded).to match("#{another_question.title.truncate(100)}")
      end
    end

    describe 'then no new questions' do
      it "renders the body" do
        expect(mail.body.encoded).to match("Where is no new question in the last 24 hours")
      end
    end
  end
end
