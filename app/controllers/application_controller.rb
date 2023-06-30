# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :gon_user

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user.present? ? current_user.id : nil
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
end
