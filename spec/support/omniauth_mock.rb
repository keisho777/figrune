module OmniauthMocks
  def line_mock
    OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new({
      "provider" => "line",
      "uid" => "123456",
      "info" => {
        "name" => "Mock User",
        # "image" => "http://mock_image_url.com"
      },
      "credentials" => {
        "token" => "mock_credentails_token",
        "secret" => "mock_credentails_secret"
      }
    })
  end
end
