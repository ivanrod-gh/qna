class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(user, question)
    Services::Subscription.new.send_notify(user, question)
  end
end
