class UserCourseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @user_course = UserCourse.new(user_course_params)
    if @user_course.save
      flash[:success] = 'Register Successfully'
    else
      flash[:danger] = 'Register Fail'
    end
    redirect_to request.referrer
  end

  private

  def user_course_params
    params.permit(:course_id, :user_id)
  end
end
