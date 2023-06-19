# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :find_answer, only: %i[update destroy best_mark]
  after_action :publish_answer, only: :create

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge!(user: current_user))
    @comment = Comment.new
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
    @comment = Comment.new
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def mark_best_answer
    @answer.question.answers.each do |answer|
      if answer == @answer
        answer.update(best: true)
        assign_reward_achievement(answer) if @answer.question.reward.present?
      elsif answer.best == true
        answer.update(best: false)
      end
    end
  end

  def assign_reward_achievement(answer)
    reward = answer.question.reward
    if reward.reward_achievement.present?
      reward.reward_achievement.update(user: answer.user)
    else
      reward.reward_achievement = RewardAchievement.create(user: answer.user, reward: reward)
    end
  end

  def publish_answer
    return unless @answer.errors.empty?

    @response = publish_answer_json_response
    add_info_to_publish_answer
    ActionCable.server.broadcast "questions_#{@answer.question.id}_show", @response
  end

  def publish_answer_json_response
    @answer.as_json(
      except: %i[created_at updated_at],
      include: {
        links: { except: %i[created_at updated_at linkable_type linkable_id] },
        files: { except: %i[created_at updated_at record_type record_id blob_id] },
        user: { only: :email },
        question: { only: :user_id }
      }
    )
  end

  def add_info_to_publish_answer
    publish_answer_links
    publish_answer_files
    publish_answer_global
  end

  def publish_answer_links
    @response['links'].each do |item|
      link = Link.find_by(id: item['id'])
      if link.gist?
        item['gist?'] = link.gist?
        item['gist_id'] = link.gist_id
      end
    end
  end

  def publish_answer_files
    @response['files'].each do |item|
      attach = ActiveStorage::Attachment.find_by(id: item['id'])
      item['name'] = attach.filename.to_s
      item['url'] = Rails.application.routes.url_helpers.rails_blob_path(attach, only_path: true)
    end
  end

  def publish_answer_global
    @response['rating'] = @answer.rating
    @response['table'] = 'answers'
    @response['controller'] = 'answers_controller'
    @response['action'] = 'create'
  end
end
