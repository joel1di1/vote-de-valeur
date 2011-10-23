class RemoveTimeStampsFromVotes < ActiveRecord::Migration
  def up
    remove_column :votes, :created_at
    remove_column :votes, :updated_at
    remove_column :classic_votes, :created_at
    remove_column :classic_votes, :updated_at
  end

  def down
    change_table :votes do |t|
      t.timestamps
    end
    change_table :classic_votes do |t|
      t.timestamps
    end
  end
end
