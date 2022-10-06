class UsersController < ApplicationController
  before_action :fetch_user, except: %i[new create index]
  before_action :logged_in_user, except: %i[new create show]
  def index
    @users = User.paginate(page: params[:page], per_page: 15)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Success!'
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render :edit
    end
  end

  def following
    @title = 'Following'
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
  end

  def fetch_user
    @user = User.find_by_id(params[:id])
    return if @user.present?

    flash[:danger] = 'User not found'
    redirect_to root_path
  end
end
