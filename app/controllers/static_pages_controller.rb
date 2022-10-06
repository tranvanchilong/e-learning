class StaticPagesController < ApplicationController
  def home
    @courses = Course.includes(:lessons).all.limit(6)
  end
end
