module Admin
  class CoursesController < AdminController
    before_action :take_course, only: %i[edit update destroy]

    def index
      @courses = Course.order_name_course.paginate(page: params[:page], per_page: Settings.paginate)
    end

    def new
      @course = Course.new
    end

    def create
      @course = Course.new(course_params)
      if @course.save
        flash[:success] = 'Add success'
        redirect_to admin_courses_path
      else
        flash[:danger] = 'Add fail'
        render new_admin_course_path
      end
    end

    def edit; end

    def update
      if @course.update course_params
        flash[:success] = 'Profile updated'
        redirect_to admin_courses_path
      else
        flash[:danger] = 'Profile update fail'
        render admin_courses_path
      end
    end

    def destroy
      if @course.destroy
        flash[:success] = 'Delete success'
        redirect_to admin_courses_path
      else
        flash[:danger] = 'Delete fail'
        render admin_courses_path
      end
    end

    private

    def course_params
      params.require(:course).permit(:name, :description)
    end

    def take_course
      @course = Course.find_by_id(params[:id])
      return if @course.present?

      flash[:danger] = 'User not found'
      redirect_to admin_courses_path
    end
  end
end
