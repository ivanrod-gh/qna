# frozen_string_literal: true

class UsersController < ApplicationController
  def rewards
    @reward_achievements = current_user.reward_achievements
  end
end
