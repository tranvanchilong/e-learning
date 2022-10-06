class AddCourseIdToWords < ActiveRecord::Migration[6.0]
  def change
    add_reference :words, :course, null: false, foreign_key: true
  end
end
