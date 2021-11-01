class RemoveReferenceNullFromUserToQuestion < ActiveRecord::Migration[6.1]
  def change
    remove_reference :questions, :user, null: false
  end
end
