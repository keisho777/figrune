class AccountSettingsController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = current_user
  end

  def edit_email
    @user = current_user
    @user.email = ""
  end

  def edit_password
    @user = current_user
  end

  def update_email
    @user = current_user
    if @user.update_without_password(email_params)
      redirect_to account_setting_path, notice: t("defaults.flash_message.account_setting.updated")
    else
      flash.now[:alert] = t("defaults.flash_message.account_setting.failured", action_word: @user.email_action_word)
      render :edit_email, status: :unprocessable_entity
    end
  end

  def update_password
    @user = current_user
    # パスワードを設定している人は現在のパスワードも確認する
    if @user.has_password
      # 現在のパスワードが空の場合のバリデーション
      if change_password_params[:current_password].blank?
        @user.errors.add(:current_password, t("defaults.error_message.blank"))
      end
      # 新しいパスワードが空の場合のバリデーション
      if change_password_params[:password].blank?
        @user.errors.add(:new_password, t("defaults.error_message.blank"))
      end
      # 新しいパスワードが6文字未満の場合のバリデーション
      if change_password_params[:password].present? && change_password_params[:password].length < User.password_length.min
        @user.errors.add(:new_password, t("defaults.error_message.short", min: User.password_length.min))
      end
      # 新しいパスワード（確認）と新しいパスワードの値が一致してない場合のバリデーション
      if change_password_params[:password] != change_password_params[:password_confirmation]
        @user.errors.add(:new_password_confirmation, t("defaults.error_message.confirmation"))
      end
      # エラーがあれば表示
      return render :edit_password, status: :unprocessable_entity if @user.errors.present?

      if @user.update_with_password(change_password_params)
        bypass_sign_in(@user)
        redirect_to account_setting_path, notice: t("defaults.flash_message.account_setting.password_updated")
      else
        flash.now[:alert] = t("defaults.flash_message.account_setting.not_updated")
        render :edit_password, status: :unprocessable_entity
      end
    # パスワードを設定してない人向け（外部サービスでログインした人）
    else
      if @user.update(setting_password_params.merge(has_password: true))
        bypass_sign_in(@user)
        redirect_to account_setting_path, notice: t("defaults.flash_message.account_setting.password_setting")
      else
        flash.now[:alert] = t("defaults.flash_message.account_setting.not_setting")
        render :edit_password, status: :unprocessable_entity
      end
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
