# frozen_string_literal: true

module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :comment
  end

  def comment
    authorize! :comment, @commentable
    @comment = @commentable.comments.create(commentable_params.merge!(user: current_user))

    @response = comment_json_response
    add_info_to_comment

    channel_id = @comment.commentable_type == 'Question' ? @commentable.id : @commentable.question.id
    ActionCable.server.broadcast "questions_#{channel_id}_show", @response
  end

  private

  def set_commentable
    @commentable = params[:table].classify.constantize.find(params[:id])
  end

  def commentable_params
    params.require(:comment).permit(:body)
  end

  def comment_json_response
    @comment.as_json(
      only: %i[id body commentable_id user_id],
      include: {
        user: { only: :email }
      }
    )
  end

  def add_info_to_comment
    comment_errors
    comment_global
  end

  def comment_errors
    if @comment.errors.present?
      @response['errors'] = {
        'pluralize' => @comment.errors.count < 2 ? 'single' : 'multiple',
        'count' => @comment.errors.count,
        'full_messages' => @comment.errors.full_messages
      }
    end
  end

  def comment_global
    @response['table'] = params[:table]
    @response['controller'] = 'commented'
    @response['action'] = 'create'
  end
end
