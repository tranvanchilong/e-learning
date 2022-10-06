class PasswordResetsController < ApplicationController
  before_action :fetch_user, :valid_user, :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      log_in @user
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def password_blank?
    params[:user][:password].blank?
  end

  def fetch_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash.now[:danger] = 'User not found'
    redirect_to new_password_reset_path
  end

  def valid_user
    redirect_to root_url unless @user&.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password reset has expired.'
    redirect_to new_password_reset_url
  end
end
