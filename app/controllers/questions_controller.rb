# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]
  before_action :new_answer, only: :show

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @question.user == current_user
      @question.destroy
      redirect_to questions_path
    else
      redirect_to questions_path, notice: "You are not be able to perform this action."
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def new_answer
    @answer = Answer.new
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
