class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :fetch_user, only: %i[create destroy]
  skip_before_action :verify_authenticity_token

  def create
    current_user.follow(@user)
    redirect_to @user
  end

  def destroy
    current_user.unfollow(@user)
    redirect_to @user
  end

  private

  def fetch_user
    @user = User.find_by_id(params[:id])
    return if @user.present?

    flash[:danger] = 'User not found'
    redirect_to root_path
  end
end
