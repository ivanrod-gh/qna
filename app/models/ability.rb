# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      user.admin? ? admin_abilities : user_abilities(user)
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can %i[index show], Question
  end

  def user_abilities(user)
    can %i[index show new create comment subscription], Question
    can %i[update destroy], Question, user_id: user.id
    can %i[like dislike], Question do |votable|
      votable.user.id != user.id
    end

    can %i[create comment], Answer
    can %i[update destroy], [Answer], user_id: user.id
    can %i[like dislike], Answer do |votable|
      votable.user.id != user.id
    end
    can :best_mark, Answer do |answer|
      answer.question.user.id == user.id
    end

    can :destroy, Link do |link|
      link.linkable.user.id == user.id
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      attachment.record.user.id == user.id
    end

    can :destroy, Comment, user_id: user.id

    can %i[rewards me all_others], User
  end

  def admin_abilities
    can :manage, :all
  end
end
