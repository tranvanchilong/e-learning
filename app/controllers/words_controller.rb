class WordsController < ApplicationController
  before_action :fetch_lession, only: [:show]
  def show; end

  private

  def fetch_lession
    @lesson = Lesson.includes(:words)
                    .find_by_id(params[:lesson_id])
    return unless @lesson.blank?

    flash[:danger] = 'The lesson is not available'
    redirect_to courses_path
  end
end
