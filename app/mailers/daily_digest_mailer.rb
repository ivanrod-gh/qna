class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where("created_at > ?", 1.day.ago)

    mail to: user.email, subject: 'QnA: daily digest of questions'
  end
end
