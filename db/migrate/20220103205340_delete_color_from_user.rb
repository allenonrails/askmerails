class DeleteColorFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :color
  end
end
