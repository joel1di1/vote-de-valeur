class VotesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @candidates = Candidate.all
    @votes = current_user.votes

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @votes }
    end
  end

end
