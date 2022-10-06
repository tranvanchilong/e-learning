class CoursesController < ApplicationController
  before_action :fetch_course, except: [:index]
  before_action :logged_in_user, except: %i[index show]
  def index
    @courses = Course.includes(:lessons).all
  end

  def show; end

  def words
    @words = @course.words
    word_course = Word.where(course_id: @course.id)
    @words =  case params[:filter]
              when 'learned'
                Word.where(id: current_user.user_words.pluck(:word_id), course_id: @course.id)
              when 'unlearn'
                word_course.where.not(id: current_user.user_words.pluck(:word_id))
              when 'all'
                @words
              else word_course.where('en_word ILIKE ?', "#{params[:key]}%")
              end
  end

  private

  def fetch_course
    @course = Course.includes(:lessons)
                    .find_by_id(params[:id])
    return unless @course.blank?

    flash[:danger] = 'Could not found this course'
    redirect_to courses_path
  end
end
