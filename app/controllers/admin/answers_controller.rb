module Admin
  class AnswersController < AdminController
    before_action :take_question, only: [:new]
    before_action :take_answer, except: %i[new create]

    def new
      @answer = Answer.new
      respond_to do |format|
        format.js { render 'new', layout: false }
      end
    end

    def create
      @answer = Answer.new(answer_params)
      if @answer.save
        flash[:success] = 'Add new answer success'
      else
        flash[:danger] = 'Create answer fail'
      end
      redirect_to request.referrer
    end

    def edit
      respond_to do |format|
        format.js { render 'edit', layout: false }
      end
    end

    def update
      if @answer.update answer_params
        flash[:success] = 'Update answer success'
      else
        flash[:danger] = 'Update answer fail'
      end
      redirect_to request.referrer
    end

    def destroy
      if @answer.destroy
        flash[:success] = 'Delete answer success'
        redirect_to request.referrer
      else
        flash[:danger] = 'Delete answer fail'
        render admin_lessons_path
      end
    end

    private

    def answer_params
      params.require(:answer).permit(:answer, :question_id, :is_key)
    end

    def take_answer
      @answer = Answer.find_by_id(params[:id] || params[:answer][:answer_id])
      return unless @answer.blank?

      flash[:danger] = 'The answer is not available'
    end

    def take_question
      @question = Question.find_by_id(params[:question_id])
      return unless @question.blank?

      flash[:danger] = 'The question is not available'
      redirect_to admin_lessons_path
    end
  end
end
