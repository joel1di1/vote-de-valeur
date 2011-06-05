class VotesController < ApplicationController

  before_filter :authenticate_user!

  # GET /votes
  # GET /votes.xml
  def index
    @votes = Vote.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @votes }
    end
  end

end
