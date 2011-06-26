class CreateClassicVotes < ActiveRecord::Migration
  def self.up
    create_table :classic_votes do |t|
      t.references :user
      t.references :candidate

      t.timestamps
    end
  end

  def self.down
    drop_table :classic_votes
  end
end
