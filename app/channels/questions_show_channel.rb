class QuestionsShowChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def questions_show_follow(data)
    stream_from "questions_#{data['question_id']}_show"
  end
end
