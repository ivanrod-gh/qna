# frozen_string_literal: true

class CommentsController < ApplicationController
  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      perform_destroy(@comment)
    else
      redirect_to questions_path, notice: "You are not be able to perform this action."
    end
  end

  private

  def perform_destroy(comment)
    comment.destroy
    respond = comment.as_json(only: %i[id commentable_id])
    respond['controller'] = 'comments_controller'
    respond['action'] = 'destroy'
    channel_id = @comment.commentable_type == 'Question' ? @comment.commentable.id : @comment.commentable.question.id
    ActionCable.server.broadcast "questions_#{channel_id}_show", respond
  end
end
