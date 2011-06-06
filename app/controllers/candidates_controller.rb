class CandidatesController < ApplicationController
  before_filter :authenticate_user!
  def index
    @candidates = Candidate.all
  end
end
