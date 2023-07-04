# Preview all emails at http://localhost:3000/rails/mailers/subscription
class SubscriptionPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscription/notify
  def notify
    user = User.first
    question = Question.first
    SubscriptionMailer.notify(user, question)
  end

end
