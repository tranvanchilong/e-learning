class CreateWords < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.text :en_word
      t.text :vi_word
      t.text :description
      t.references :lesson, null: false, foreign_key: true

      t.timestamps
    end
  end
end
