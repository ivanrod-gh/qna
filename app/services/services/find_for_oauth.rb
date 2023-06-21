class Services::FindForOauth
  attr_reader :auth
  
  def initialize(auth)
    @auth = auth
  end
  
  def call
    return nil if !auth.provider || !auth.uid || !auth.info[:email]

    authorization = Authorization.find_by(provider: auth.provider.to_s, uid: auth.uid.to_s)
    return authorization.user if authorization
    
    email = auth.info[:email]
    user = User.find_by(email: email)
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
