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
      flash.now[:alert] = t("defaults.flash_message.account_setting.not_updated")
      render :edit_email, status: :unprocessable_entity
    end
  end

  def update_password
    @user = current_user
    if password_params[:current_password].blank?
        @user.errors.add(:current_password, :blank)
        return render :edit_password, status: :unprocessable_entity
    end

    if password_params[:password].blank?
        @user.errors.add(:password, :blank)
        return render :edit_password, status: :unprocessable_entity
    end

    if @user.update_with_password(password_params)
      bypass_sign_in(@user)
      redirect_to account_setting_path, notice: t("defaults.flash_message.account_setting.password_updated")
    else
      flash.now[:alert] = t("defaults.flash_message.account_setting.not_updated")
      render :edit_password, status: :unprocessable_entity
    end
  end

  def update_email_notification_timing
    @user = current_user
    if @user.update(email_notification_timing_params)
      redirect_to account_setting_path
    else
      flash.now[:alert] = t("defaults.flash_message.account_setting.not_updated")
      render :show, status: :unprocessable_entity
    end
  end

  private

  def email_params
    params.require(:user).permit(:email)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def email_notification_timing_params
    params.require(:user).permit(:email_notification_timing)
  end
end
