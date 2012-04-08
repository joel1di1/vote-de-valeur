class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :answers
      t.string :key
      t.timestamps
    end

    add_index :feedbacks, :key, :unique => false
  end
end
