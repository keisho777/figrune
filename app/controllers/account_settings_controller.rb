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

  def update_password
    action_word = @user.has_password_in_database ? t("account_settings.update") : t("account_settings.setup")

    # result = @user.has_password_in_database ? @user.update_with_password(change_password_params) : @user.update(setting_password_params.merge(has_password: true))
    result =
      if @user.has_password_in_database
        @user.errors.add(:password, :blank) if change_password_params[:password].blank?
        @user.errors.add(:current_password, :blank) if change_password_params[:current_password].blank?

        if @user.errors.any?
          false
        else
          @user.update_with_password(change_password_params)
        end
      else
        @user.update(setting_password_params.merge(has_password: true))
      end

    if result
      bypass_sign_in(@user)
      redirect_to account_setting_path, notice: t(".success", action_word: action_word)
    else
      flash.now[:alert] = t(".failure", action_word: action_word)
      render :edit_password, status: :unprocessable_entity
    end
  end

  # メール通知のセレクトボックスが変化したら実行
  def update_email_notification_timing
    if @user.update(email_notification_timing_params)
      redirect_to account_setting_path
    else
      flash.now[:alert] = t(".failure")
      render :show, status: :unprocessable_entity
    end
  end

  # LINE通知のセレクトボックスが変化したら実行
  def update_line_notification_timing
    if @user.update(line_notification_timing_params)
      redirect_to account_setting_path
    else
      flash.now[:alert] = t(".failure")
      render :show, status: :unprocessable_entity
    end
  end

  def confirm_destroy; end

  private

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
