class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    basic_action
  end

  private

  def basic_action
    @omniauth = request.env["omniauth.auth"]
    
    # 認証情報の確認
    return redirect_to new_user_session_path, alert: "認証に失敗しました" if @omniauth.blank?

    # 認証情報の検索・紐付け
    @authentication = Authentication.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])

    # すでに連携済みならログイン、新規登録ならUserとAuthenticationを登録
    if @authentication.user.blank?
      # emailの取得ができなかった場合はダミーのメールアドレスを使用
      email = @omniauth["info"]["email"] ? @omniauth["info"]["email"] : "#{@omniauth["uid"]}-#{@omniauth["provider"]}@example.com"
      user = User.new(email: email, password: Devise.friendly_token[0, 20], has_email: @omniauth["info"]["email"].present?, has_password: false)
      
      # 認証メールのスキップ
      user.skip_confirmation!
      unless user.save
        return redirect_to new_user_session_path, alert: t("defaults.flash_message.omniauth_callback.email_taken")
      end
      @authentication.user = user
      unless @authentication.save
        return redirect_to new_user_session_path, alert: t("defaults.flash_message.omniauth_callback.auth_save_failure")
      end
    end

    # ログイン処理
    sign_in(:user, @authentication.user)
    redirect_to home_path, notice: t("devise.sessions.signed_in")
  end
end
