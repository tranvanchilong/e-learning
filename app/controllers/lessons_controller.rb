class LessonsController < ApplicationController
  before_action :take_lesson

  def index; end

  def create
    words_ids = @lesson.words.pluck(:id)
    words_userword_ids = UserWord.where(user_id: current_user.id).pluck(:word_id) || []
    userword_attrs = (words_ids - words_userword_ids).map do |id|
      { word_id: id, user_id: current_user.id }
    end

    UserWord.bulk_insert(:word_id, :user_id, :created_at, :updated_at) do |worker|
      userword_attrs.each do |attr|
        worker.add(attr)
      end
    end

    if current_user.user_lessons.exists?(lesson_id: @lesson.id)
      flash[:success] = 'You already learned this lesson'
    else
      user_lesson = UserLesson.new(user_lesson_params)
      if user_lesson.save
        flash[:success] = 'You have completed this lesson'
      else
        flash[:danger] = 'Save to User Lesson Failed'
        redirect_to course_path(@lesson.course.id)
      end
    end

    redirect_to practice_learning_index_path(lesson_id: @lesson.id)
  end

  def practice
    @questions = Question.includes(:answers).where(lesson_id: @lesson.id)
  end

  private

  def take_lesson
    @lesson = Lesson.includes(:words)
                    .find_by_id(params[:lesson_id])
    return unless @lesson.blank?

    flash[:danger] = 'The lesson is not available'
    redirect_to courses_path
  end

  def user_lesson_params
    defaults = { user_id: current_user.id }
    params.permit(:lesson_id, :user_id).reverse_merge(defaults)
  end
end
