class ClassicVote < ActiveRecord::Base
  belongs_to :user, :autosave => true
  belongs_to :candidate
end
