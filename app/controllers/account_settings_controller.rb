class AccountSettingsController < ApplicationController
  def show; end

  def edit_email
    @user = current_user
    @user.email = ""
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

  private

  def email_params
    params.require(:user).permit(:email)
  end
end
