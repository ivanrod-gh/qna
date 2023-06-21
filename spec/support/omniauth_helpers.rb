module OmniauthHelpers
  def mock_auth_github_valid_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123545',
      'info' => {
        'name' => 'mockuser',
        'email' => 'mock_user@email'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end

  def mock_auth_github_invalid_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new
  end

  def mock_auth_yandex_valid_hash
    OmniAuth.config.mock_auth[:yandex] = OmniAuth::AuthHash.new({
      'provider' => 'yandex',
      'uid' => '123545',
      'info' => {
        'name' => 'mock_user@email',
        'email' => 'mock_user@email'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end

  def mock_auth_yandex_invalid_hash
    OmniAuth.config.mock_auth[:yandex] = OmniAuth::AuthHash.new
  end
end
