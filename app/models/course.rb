class Course < ActiveRecord::Base
  has_many :user_courses
  has_many :lessons, dependent: :destroy
  has_many :words
  scope :order_name_course, -> { order(name: :ASC) }
end
