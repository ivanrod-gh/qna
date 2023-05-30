# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy best_mark]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge!(user: current_user))
  end

  def update
    if @answer.user == current_user
      @answer.update(answer_params)
      @question = @answer.question
    else
      redirect_to question_path(@answer.question), notice: "You are not be able to perform this action."
    end
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy
    else
      redirect_to question_path(@answer.question), notice: "You are not be able to perform this action."
    end
  end

  def best_mark
    if @answer.question.user == current_user
      mark_best_answer
      @answers = @answer.question.sorted_answers
    else
      redirect_to question_path(@answer.question), notice: "You are not be able to perform this action."
    end
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

  def mark_best_answer
    @answer.question.answers.each do |answer|
      answer == @answer ? answer.update(best: true) : (answer.update(best: false) if answer.best == true)
    end
  end
end
