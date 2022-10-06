class Lesson < ActiveRecord::Base
  belongs_to  :course
  has_one     :practice
  has_many    :user_words
  has_many    :words, dependent: :destroy
  has_many    :questions, dependent: :destroy
  scope :order_name, -> { order(name: :ASC) }
  scope :order_name_lesson, -> { order(name: :ASC) }
end
