class SubscriptionMailer < ApplicationMailer
  def notify(user, question)
    @question = question

    mail to: user.email, subject: "QnA: subscription notify (#{question.title.truncate(30)})"
  end
end
