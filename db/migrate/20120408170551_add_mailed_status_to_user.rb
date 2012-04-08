class AddMailedStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :mailed_status, :integer, :default => 0
  end
end
