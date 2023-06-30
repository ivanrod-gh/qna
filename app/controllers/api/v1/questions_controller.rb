# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        authorize! :index, Question
        render json: Question.all, each_serializer: QuestionsSerializer
      end

      def show
        authorize! :show, Question
        render json: Question.find_by(id: params[:id]), serializer: QuestionSerializer
      end

      def create
        authorize! :create, Question
        title = ActionController::Base.helpers.sanitize(params[:title])
        body = ActionController::Base.helpers.sanitize(params[:body])
        Question.create(user: current_resource_user, title: title, body: body)
        head :ok
      end

      def update
        @question = Question.find_by(id: ActionController::Base.helpers.sanitize(params[:id]))
        authorize! :update, @question
        title = params[:title] ? ActionController::Base.helpers.sanitize(params[:title]) : nil
        body = params[:body] ? ActionController::Base.helpers.sanitize(params[:body]) : nil
        @question.update(
          title: title || @question.title,
          body: body || @question.body
        )
        head :ok
      end

      def destroy
        @question = Question.find_by(id: ActionController::Base.helpers.sanitize(params[:id]))
        authorize! :destroy, @question
        @question.destroy
        head :ok
      end
    end
  end
end
