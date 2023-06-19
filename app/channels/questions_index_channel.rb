class QuestionsIndexChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def questions_index_follow
    stream_from "questions_index"
  end
end
