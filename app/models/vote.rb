class Vote < ActiveRecord::Base
  belongs_to :candidate

  validates_inclusion_of :vote, :in => -2..2, :allow_nil => true
end
