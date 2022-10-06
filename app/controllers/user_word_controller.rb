class UserWordController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @user_word = UserWord.new(user_word_params)
    if @user_word.save!
      flash[:success] = 'Done Successfully'
    else
      flash[:danger] = 'Done Fail'
    end
    redirect_to request.referrer
  end

  private

  def user_word_params
    params.permit(:word_id, :user_id)
  end
end
