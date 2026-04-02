module OmniauthMocks
  def line_mock
    OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new({
      "provider" => "line",
      "uid" => "123456",
      "info" => {
        "name" => "Mock User"
      },
      "credentials" => {
        "token" => "mock_credentails_token",
        "secret" => "mock_credentails_secret"
      }
    })
  end

  def line_invalid_mock
    OmniAuth.config.mock_auth[:line] = :invalid_credentails
  end
end
