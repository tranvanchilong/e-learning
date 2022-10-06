class PracticesController < ApplicationController
  before_action :fetch_lesson, except: [:get_correct_answers]

  def create
    practice = current_user.practices.find_by(lesson_id: @lesson.id)

    if practice.blank?
      practice = Practice.new(practice_params)
    elsif practice.score < params[:score].to_i
      practice.score = params[:score]
    end

    if practice.save
      flash[:success] = 'Your results have been saved.'
    else
      flash[:danger] = 'Something went wrong! Try again.'
      redirect_to practice_learning_index_path(lesson_id: @lesson.id)
    end
  end

  def correct_answers
    questions = Question.includes(:answers).where(lesson_id: params[:lesson_id])
    custom = []
    questions.each do |q|
      custom.push(
        {
          question: q.id,
          correct_answer: q.answers.find { |a| a.is_key == true }.id
        }
      )
    end
    render json: custom
  end

  private

  def fetch_lesson
    @lesson = Lesson.includes(:words)
                    .find_by_id(params[:lesson_id])
    return unless @lesson.blank?

    flash[:danger] = 'The lesson is not available'
    redirect_to courses_path
  end

  def practice_params
    defaults = { user_id: current_user.id }
    params.permit(:score, :lesson_id, :user_id).reverse_merge(defaults)
  end
end
