class AddFavoriteToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :favorite, :boolean, :default => false
  end
end
