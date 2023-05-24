# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge!(user: current_user))
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.user == current_user
      @answer.update(answer_params)
      @question = @answer.question
    else
      redirect_to question_path(@answer.question), notice: "You are not be able to perform this action."
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.user == current_user
      @answer.destroy
    else
      redirect_to question_path(@answer.question), notice: "You are not be able to perform this action."
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
