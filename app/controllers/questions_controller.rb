# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :find_question, only: %i[show update destroy subscription]
  after_action :publish_question, only: :create

  def index
    authorize! :index, Question
    @questions = Question.all
  end

  def show
    authorize! :show, Question
    @answer = Answer.new
    @answer.links.new
    gon.question_id = @question.id
  end

  def new
    authorize! :new, Question
    @question = Question.new
    @question.links.new
    @question.reward = Reward.new
  end

  def create
    authorize! :create, Question
    @question = current_user.questions.new(question_params)
    if @question.save
      current_user.subscriptions.create(question: @question)
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    authorize! :update, @question
    @question.update(question_params)
  end

  def destroy
    authorize! :destroy, @question
    @question.destroy
    redirect_to root_path
  end

  def subscription
    authorize! :subscription, Question
    @subscription = current_user.subscriptions.where(question: @question).first
    if @subscription.present?
      Subscription.find_by(id: @subscription.id).destroy
    else
      current_user.subscriptions.create(question: @question)
    end
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
