class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :postal_code, :integer
    add_column :users, :public, :boolean, :default => false
  end

  def self.down
    remove_column :users, :public
    remove_column :users, :postal_code
    remove_column :users, :last_name
    remove_column :users, :first_name
  end
end
