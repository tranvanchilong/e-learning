class CreatePractices < ActiveRecord::Migration[6.0]
  def change
    create_table :practices do |t|
      t.integer :score
      t.references :lesson, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true


      t.timestamps
    end
  end
end
