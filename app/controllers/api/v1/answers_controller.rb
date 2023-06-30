# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      def index
        authorize! :show, Question
        render json: Answer.where(question_id: params[:question_id]), each_serializer: AnswersSerializer
      end

      def show
        authorize! :show, Question
        render json: Answer.find_by(id: params[:id]), serializer: AnswerSerializer
      end

      def create
        authorize! :create, Answer
        body = ActionController::Base.helpers.sanitize(params[:body])
        question_id = ActionController::Base.helpers.sanitize(params[:question_id])
        Answer.create(user: current_resource_user, question_id: question_id, body: body)
        head :ok
      end

      def update
        @answer = Answer.find_by(id: ActionController::Base.helpers.sanitize(params[:id]))
        authorize! :update, @answer
        body = ActionController::Base.helpers.sanitize(params[:body])
        @answer.update(body: body)
        head :ok
      end

      def destroy
        @answer = Answer.find_by(id: ActionController::Base.helpers.sanitize(params[:id]))
        authorize! :destroy, @answer
        @answer.destroy
        head :ok
      end
    end
  end
end
