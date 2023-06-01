# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if @question.user == current_user
      @question.update(question_params)
    else
      redirect_to question_path(@question), notice: "You are not be able to perform this action."
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
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url])
  end
end
