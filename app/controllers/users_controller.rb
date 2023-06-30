# frozen_string_literal: true

class UsersController < ApplicationController
  def rewards
    authorize! :rewards, User
    @reward_achievements = current_user.reward_achievements
  end
end
