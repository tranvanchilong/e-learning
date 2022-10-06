module Admin
  class WordsController < AdminController
    before_action :take_word, only: %i[edit update destroy]

    def index
      @words = Word.oder_by_name_word.paginate(page: params[:page], per_page: Settings.paginate)
    end

    def new
      @word = Word.new
      @courses = Course.all
      @lessons = Lesson.where(course_id: params[:course_id])
      return unless request.xhr?

      render json: { lessons: @lessons }
    end

    def create
      @word = Word.new(word_params)
      if @word.save
        flash[:success] = 'Add success'
        redirect_to admin_words_path
      else
        @lessons = Lesson.all
        flash[:danger] = 'Add fail'
        render :new
      end
    end

    def edit
      @courses = Course.all
      @lessons = Lesson.where(course_id: params[:course_id])
      return unless request.xhr?

      render json: { lessons: @lessons }
    end

    def update
      if @word.update word_params
        flash[:success] = 'Profile updated'
        redirect_to admin_words_path
      else
        flash[:danger] = 'Profile update fail'
        render :edit
      end
    end

    def destroy
      if @word.destroy
        flash[:success] = 'Delete success'
        redirect_to admin_words_path
      else
        flash[:danger] = 'Delete fail'
        render admin_words_path
      end
    end

    private

    def word_params
      params.require(:word).permit(:en_word, :vi_word, :description, :lesson_id, :course_id)
    end

    def take_word
      @word = Word.find_by_id(params[:id])
      return if @word.present?

      flash[:danger] = 'Word not found'
      redirect_to admin_words_path
    end
  end
end
