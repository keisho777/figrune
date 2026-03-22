class AccountSettingsController < ApplicationController
  before_action :authenticate_user!, :set_user
  def show; end

  def edit_email
    @user.email = ""
  end

  def edit_password; end

  def update_email
    if @user.update_without_password(email_params)
      redirect_to account_setting_path, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :edit_email, status: :unprocessable_entity
    end
  end

  # def update_password
  #   @user = current_user
  #   # パスワードを設定している人は現在のパスワードも確認する
  #   if @user.has_password
  #     # 現在のパスワードが空の場合のバリデーション
  #     if change_password_params[:current_password].blank?
  #       @user.errors.add(:current_password, t("defaults.error_message.blank"))
  #     end
  #     # 新しいパスワードが空の場合のバリデーション
  #     if change_password_params[:password].blank?
  #       @user.errors.add(:new_password, t("defaults.error_message.blank"))
  #     end
  #     # 新しいパスワードが6文字未満の場合のバリデーション
  #     if change_password_params[:password].present? && change_password_params[:password].length < User.password_length.min
  #       @user.errors.add(:new_password, t("defaults.error_message.short", min: User.password_length.min))
  #     end
  #     # 新しいパスワード（確認）と新しいパスワードの値が一致してない場合のバリデーション
  #     if change_password_params[:password] != change_password_params[:password_confirmation]
  #       @user.errors.add(:new_password_confirmation, t("defaults.error_message.confirmation"))
  #     end
  #     # エラーがあれば表示
  #     return render :edit_password, status: :unprocessable_entity if @user.errors.present?

  #     if @user.update_with_password(change_password_params)
  #       bypass_sign_in(@user)
  #       redirect_to account_setting_path, notice: t("defaults.flash_message.account_setting.password_updated")
  #     else
  #       flash.now[:alert] = t("defaults.flash_message.account_setting.not_updated")
  #       render :edit_password, status: :unprocessable_entity
  #     end
  #   # パスワードを設定してない人向け（外部サービスでログインした人）
  #   else
  #     if @user.update(setting_password_params.merge(has_password: true))
  #       bypass_sign_in(@user)
  #       redirect_to account_setting_path, notice: t("defaults.flash_message.account_setting.password_setting")
  #     else
  #       flash.now[:alert] = t("defaults.flash_message.account_setting.not_setting")
  #       render :edit_password, status: :unprocessable_entity
  #     end
  #   end
  # end

# def update_password
#   # 1. Formオブジェクトを初期化（ログイン中のユーザーと、送信されたパラメータを渡す）
#   @password_form = PasswordUpdateForm.new(user: current_user, **password_update_params)
#   notice_key = current_user.has_password_in_database ? ".password_updated" : ".password_setting"

#   # 2. 保存処理を実行（バリデーションや現在のパスワードチェックはForm内で完結）
#   if @password_form.save
#     # 3. パスワード更新後はセッションが切れないように再ログイン処理
#     bypass_sign_in(current_user)

#     # 4. 状況に合わせて成功メッセージを出し分け
#     redirect_to account_setting_path, notice: t(notice_key)
#   else
#     # 5. 失敗した場合は編集画面を再表示（エラーメッセージは自動で引き継がれます）
#     flash.now[:alert] = t("defaults.flash_message.account_setting.not_updated")
#     render :edit_password, status: :unprocessable_entity
#   end
# end

  def update_password
    # 1. Formオブジェクトを初期化（ログイン中のユーザーと、送信されたパラメータを渡す）
    #@password_form = PasswordUpdateForm.new(user: current_user, **password_update_params)
    action_word = @user.has_password_in_database ? t("account_settings.update") : t("account_settings.setup")

    result = @user.has_password_in_database ? @user.update_with_password(change_password_params) : @user.update(setting_password_params.merge(has_password: true))

    # 2. 保存処理を実行（バリデーションや現在のパスワードチェックはForm内で完結）
    if result
      # 3. パスワード更新後はセッションが切れないように再ログイン処理
      bypass_sign_in(@user)

      # 4. 状況に合わせて成功メッセージを出し分け
      redirect_to account_setting_path, notice: t(".success", action_word: action_word)
    else
      # パスワードが空で、且つ password に関するエラーがまだない場合、エラーを追加する
      if params[:user][:password].blank? && @user.errors[:password].blank?
        @user.errors.add(:password, :blank)
      end
      #rewrite_password_errors if @user.has_password_in_database
      # 5. 失敗した場合は編集画面を再表示（エラーメッセージは自動で引き継がれます）
      flash.now[:alert] = t(".failure", action_word: action_word)
      render :edit_password, status: :unprocessable_entity
    end
  end


  # メール通知のセレクトボックスが変化したら実行
  def update_email_notification_timing
    @user = current_user
    if @user.update(email_notification_timing_params)
      redirect_to account_setting_path
    else
      flash.now[:alert] = t("defaults.flash_message.account_setting.update_failured")
      render :show, status: :unprocessable_entity
    end
  end

  # LINE通知のセレクトボックスが変化したら実行
  def update_line_notification_timing
    @user = current_user
    if @user.update(line_notification_timing_params)
      redirect_to account_setting_path
    else
      flash.now[:alert] = t("defaults.flash_message.account_setting.update_failured")
      render :show, status: :unprocessable_entity
    end
  end

  private

# def rewrite_password_errors
#   # password のエラーを new_password に移動
#   if @user.errors[:password].present?
#     @user.errors[:password].each do |message|
#       @user.errors.add(:new_password, message)
#     end
#     @user.errors.delete(:password)
#   end

#   # password_confirmation のエラーを new_password_confirmation に移動
#   if @user.errors[:password_confirmation].present?
#     @user.errors[:password_confirmation].each do |message|
#       original_attr_name = self.class.human_attribute_name(:new_password)
#       @user.errors.add(:new_password_confirmation, :confirmation, attribute: original_attr_name)
#     end
#     @user.errors.delete(:password_confirmation)
#   end
# end

# def rewrite_password_errors
#   # password のエラーを new_password に移動
#   if @user.errors[:password].present?
#     @user.errors[:password].each do |message|
#       @user.errors.add(:new_password, message)
#     end
#     @user.errors.delete(:password)
#   end

#   # password_confirmation のエラーを new_password_confirmation に移動
#   if @user.errors[:password_confirmation].present?
#     @user.errors.details[:password_confirmation].each do |detail|
#       if detail[:error] == :confirmation
#         # confirmation エラーは i18n を使って再生成
#         @user.errors.add(
#           :new_password_confirmation,
#           :confirmation,
#           attribute: User.human_attribute_name(:new_password)
#         )
#       else
#         # その他のエラーはそのまま追加
#         @user.errors.add(:new_password_confirmation, detail[:error])
#       end
#     end
#     @user.errors.delete(:password_confirmation)
#   end
# end

  # def password_update_params
  #   params.require(:password_update_form).permit(:current_password, :new_password, :new_password_confirmation)
  # end

  def set_user
    @user = current_user
  end

  def email_params
    params.require(:user).permit(:email)
  end

  def change_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def setting_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def email_notification_timing_params
    params.require(:user).permit(:email_notification_timing)
  end

  def line_notification_timing_params
    params.require(:user).permit(:line_notification_timing)
  end
end
