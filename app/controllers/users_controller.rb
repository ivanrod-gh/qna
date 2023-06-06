# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def rewards
    @reward_achievements = current_user.reward_achievements
  end
end
