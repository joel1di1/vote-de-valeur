class AddFeedbackToUser < ActiveRecord::Migration
  def change
    add_column :users, :feedbacks, :boolean
  end
end
