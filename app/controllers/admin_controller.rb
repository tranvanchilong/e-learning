class AdminController < ApplicationController
  before_action :check_permission, only: [:index]
  before_action :admin?, only: [:index]

  def index
    @user_count = User.count
    @course_count = Course.count
    @lesson_count = Lesson.count
    @word_count = Word.count
  end

  private

  def check_permission
    redirect_to login_path if current_user.blank?
  end

  def admin?
    return if current_user&.is_admin

    flash[:danger] = 'You are not authorized to view that page.'
    redirect_to root_path
  end
end
