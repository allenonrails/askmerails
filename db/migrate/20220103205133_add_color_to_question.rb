class AddColorToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :color, :string
  end
end
