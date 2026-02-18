class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    basic_action
  end

  private

  def basic_action
    @omniauth = request.env["omniauth.auth"]

    # 認証情報の確認
    return redirect_to new_user_session_path, alert: t("defaults.flash_message.omniauth_callback.invalid_credential") if @omniauth.blank?

    # 認証情報の検索
    @authentication = Authentication.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])

    # 認証情報にuser_idがあればログイン、なければ新規登録
    if @authentication.user.blank?
      register_external_user(@omniauth, @authentication)
    else
      authenticate_external_user(@omniauth, @authentication)
    end
  end

  # 新規登録用
  def register_external_user(omniauth, authentication)
    email = omniauth["info"]["email"] || "#{omniauth["uid"]}-#{omniauth["provider"]}@example.com"
    user = User.new(email: email, password: Devise.friendly_token[0, 20], has_email: omniauth["info"]["email"].present?, has_password: false)

    # 認証メールのスキップ
    user.skip_confirmation!
    ActiveRecord::Base.transaction do
      # ユーザー登録
      user.save!
      # user_id、provider、uidの登録
      authentication.user = user
      authentication.save!
    end
    sign_in(:user, authentication.user)
    redirect_to home_path, notice: t("devise.registrations.signed_up")

    # 登録時、すでに同じメールアドレスが登録されている場合、ここでキャッチされる
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error(I18n.t("defaults.omniauth_error_log", error_class: e.class, error_message: e.message))
      redirect_to new_user_registration_path, alert: e.message
    # 予期せぬエラー
    rescue => e
      Rails.logger.error(I18n.t("defaults.omniauth_unexpected_error_log", error_class: e.class, error_message: e.message))
      redirect_to new_user_registration_path, alert: t("defaults.unexpected_error")
  end

  # ログイン用
  def authenticate_external_user(omniauth, authentication)
    sign_in(:user, authentication.user)
    redirect_to home_path, notice: t("devise.sessions.signed_in")
  end
end
