class VotesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @candidates = Candidate.all
    @user = current_user

    respond_to do |format|
      format.html
      format.xml { render :xml => @votes }
    end
  end

  def update
    current_user.votes.clear

    Candidate.all.each do |candidate|
      value_string = params[:user]["vote_for_candidate_#{candidate.id}"]
      vote_value = value_string.to_i if (value_string && value_string.match(/^-?\d+$/) )
      vote_value ||= nil
      vote = Vote.new :user => current_user, :candidate => candidate, :vote => vote_value
      current_user.votes << vote
    end

    redirect_to votes_url, :notice => "modifications prise en compte"
  end

end
