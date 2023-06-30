class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def github
    perform_callback
  end

  def yandex
    perform_callback
  end

  private

  def perform_callback
    @user = Services::FindForOauth.new(request.env['omniauth.auth']).call
    
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: "#{request.env['omniauth.auth'].provider.capitalize}")
      end
    else
      redirect_to root_path, alert: 'Authentication failed.'
    end
  end
end
