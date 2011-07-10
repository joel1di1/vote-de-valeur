class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :configurations
  end
end
