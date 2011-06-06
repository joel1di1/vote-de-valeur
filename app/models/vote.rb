class Vote < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :user

  validates_inclusion_of :vote, :in => -2..2, :allow_nil => true

end
