# frozen_string_literal: true

class UsersController < ApplicationController
  authorize_resource

  def rewards
    @reward_achievements = current_user.reward_achievements
  end
end
