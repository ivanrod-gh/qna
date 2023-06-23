# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted
  include Commented

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :find_question, only: %i[show update destroy]
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.links.new
    @question.reward = Reward.new
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
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to root_path
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
    @comment = Comment.new
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: %i[id name url _destroy],
      reward_attributes: %i[name file]
    )
  end

  def publish_question
    if @question.errors.empty?
      ActionCable.server.broadcast 'questions_index',
                                   ApplicationController.render(
                                     partial: 'questions/question_header',
                                     locals: { question: @question }
                                   )
    end
  end
end
