class AddIsLearnedToUserCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :user_courses, :is_learned, :boolean, default: false
  end
end
