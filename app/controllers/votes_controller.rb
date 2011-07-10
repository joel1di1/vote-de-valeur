class VotesController < ApplicationController

  before_filter :authenticate_user!

  def index
    if DateHelper.election_running?
      @candidates = Candidate.all
      @user = current_user

      respond_to do |format|
        format.html
      end
    else
      flash[:error] = "Le bureau de vote n'est pas ouvert"
      redirect_to root_path
    end
  end

  def update
    if DateHelper.election_running?
      current_user.votes.clear

      Candidate.all.each do |candidate|
        value_string = params[:user]["vote_for_candidate_#{candidate.id}"]

        vote_value = parse_vote_value value_string

        vote = Vote.new :user => current_user, :candidate => candidate, :vote => vote_value
        current_user.votes << vote
      end

      current_user.classic_vote = ClassicVote.create :user => current_user unless current_user.classic_vote
      current_user.classic_vote.candidate = Candidate.find(params[:user][:classic_vote])
      current_user.classic_vote.save

      redirect_to votes_url, :notice => "modifications prise en compte"
    else
      flash[:error] = "Le bureau de vote n'est pas ouvert"
      redirect_to root_path
    end
  end


  def parse_vote_value value_string
    vote_value = value_string.to_i if (value_string && value_string.match(/^[-+]?\d+$/))
    vote_value ||= nil
  end

end
