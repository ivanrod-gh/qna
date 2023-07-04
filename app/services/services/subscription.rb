module Services
  class Subscription
    def send_notify(user, question)
      SubscriptionMailer.notify(user, question).deliver_later
    end
  end
end
