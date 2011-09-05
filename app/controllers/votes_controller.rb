#coding: UTF-8
class VotesController < ApplicationController

  TOKEN_VALIDATED_KEY = 'token_validated'

  def index
    if user_signed_in?
      if DateHelper.election_running?
        if session.include?(TOKEN_VALIDATED_KEY) && session[TOKEN_VALIDATED_KEY]
          @candidates = Candidate.all
          @user = current_user

          respond_to do |format|
            format.html
          end
        else
          flash[:error] = "Veuillez suivre le lien qui vous a été envoyé par mail pour valider votre inscription."
          redirect_to root_path
        end
      else
        flash[:error] = "Le bureau de vote n'est pas ouvert"
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def update
    if user_signed_in?
      if DateHelper.election_running?
        current_user.votes.clear

        Candidate.all.each do |candidate|
          value_string = nil
          value_string = params[:user]["vote_for_candidate_#{candidate.id}"] if params[:user]

          vote_value = parse_vote_value value_string

          vote = Vote.new :user => current_user, :candidate => candidate, :vote => vote_value
          current_user.votes << vote
        end

        current_user.classic_vote = ClassicVote.create :user => current_user unless current_user.classic_vote
        if params[:user] && params[:user][:classic_vote]
          current_user.classic_vote.candidate = Candidate.find(params[:user][:classic_vote])
          current_user.classic_vote.save
        end

        current_user.a_vote = true
        current_user.save

        redirect_to votes_url, :notice => "modifications prise en compte"
      else
        flash[:error] = "Le bureau de vote n'est pas ouvert"
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def parse_vote_value value_string
    vote_value = value_string.to_i if (value_string && value_string.match(/^[-+]?\d+$/))
    vote_value ||= nil
  end

end
