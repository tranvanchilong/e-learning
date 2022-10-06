class CreateBoos < ActiveRecord::Migration[6.0]
  def change
    create_table :boos do |t|
      t.string :name

      t.timestamps
    end
  end
end
