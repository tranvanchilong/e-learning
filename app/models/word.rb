class Word < ActiveRecord::Base
  has_many    :user_words
  belongs_to  :lesson
  belongs_to  :course
  validates :en_word, presence: true, uniqueness: true
  validates :vi_word, presence: true
  scope :oder_by_name_word, -> { order(en_word: :ASC) }
end
