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
    can :read, :all
  end

  def user_abilities(user)
    can :read, :all
    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer], user_id: user.id
    can :best_mark, Answer do |answer|
      answer.question.user.id == user.id
    end
    can :rewards, User
    can :destroy, Link do |link|
      link.linkable.user.id == user.id
    end
    can :destroy, ActiveStorage::Attachment do |attachment|
      attachment.record.user.id == user.id
    end
    can :comment, [Question, Answer]
    can :destroy, Comment, user_id: user.id
    can %i[like dislike], [Question, Answer] do |votable|
      votable.user.id != user.id
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
