#coding: UTF-8
class VotesController < ApplicationController

  TOKEN_VALIDATED_KEY = 'token_validated'

  def index
    redirect_to root_path and return unless user_signed_in?
    unless DateHelper.election_running?
      flash[:error] = "Le bureau de vote n'est pas ouvert"
      redirect_to root_path and return
    end

    if session.include?(TOKEN_VALIDATED_KEY) && session[TOKEN_VALIDATED_KEY]
      @candidates = Candidate.all
      @user = current_user
      if current_user.a_vote?
        if current_user.a_vote_classic?
          flash[:error] = "Vous avez déjà voté."
          redirect_to root_path
        else
          redirect_to votes_classic_path
        end
      end
    else
      flash[:error] = "Veuillez suivre le lien qui vous a été envoyé par mail pour valider votre inscription."
      redirect_to root_path
    end
  end

  def classic
    unless user_signed_in?
      redirect_to root_path and return
    end

    unless DateHelper.election_running?
      flash[:error] = "Le bureau de vote n'est pas ouvert"
      redirect_to root_path and return
    end

    if current_user.a_vote_classic?
      if current_user.a_vote?
        flash[:error] = "Vous avez déjà voté"
        redirect_to root_path
      else
        redirect_to votes_path
      end
      return
    end

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
  end

  def update
    unless user_signed_in?
      redirect_to root_path and return
    end


    unless DateHelper.election_running?
      flash[:error] = "Le bureau de vote n'est pas ouvert"
      redirect_to root_path and return
    end

    if current_user.a_vote?
      flash[:error] = "Vous avez déjà voté"
      redirect_to root_path and return
    end

    Candidate.all.each do |candidate|
      value_string = nil
      value_string = params[:user]["vote_for_candidate_#{candidate.id}"] if params[:user]

      vote_value = parse_vote_value value_string

      Vote.create :candidate => candidate, :vote => vote_value
    end

    current_user.update_attribute :a_vote, true

    redirect_to votes_classic_path
  end

  def update_classic
    unless user_signed_in?
      redirect_to root_path
      return
    end

    unless DateHelper.election_running?
      flash[:error] = "Le bureau de vote n'est pas ouvert"
      redirect_to root_path
      return
    end

    if current_user.a_vote_classic?
      flash[:error] = "Vous avez déjà voté"
      redirect_to root_path
      return
    end

    candidate = Candidate.find(params[:user][:classic_vote]) if params[:user] && params[:user][:classic_vote]
    ClassicVote.create :candidate => candidate if candidate

    current_user.update_attribute :a_vote_classic, true

    redirect_to thanks_path
  end

  def parse_vote_value value_string
    vote_value = value_string.to_i if (value_string && value_string.match(/^[-+]?\d+$/))
    vote_value ||= nil
  end

  def explanations

  end

end
