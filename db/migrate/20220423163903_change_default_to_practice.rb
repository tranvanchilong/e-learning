class ChangeDefaultToPractice < ActiveRecord::Migration[6.0]
  def change
    change_column_default :practices, :created_at, from: nil, to: ->{ 'current_timestamp' }
    change_column_default :practices, :updated_at, from: nil, to: ->{ 'current_timestamp' }
  end
end
