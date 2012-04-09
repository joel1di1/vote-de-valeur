#coding: UTF-8
class VotesController < ApplicationController

  TOKEN_VALIDATED_KEY = 'token_validated'

  before_filter :set_cache_buster

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
        flash[:error] = "Vous avez déjà voté."
        redirect_to root_path
      end
    else
      flash[:error] = "Veuillez suivre le lien qui vous a été envoyé par mail pour valider votre inscription."
      redirect_to root_path
    end
  end

  def create
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

    key = current_user.vote! params[:user]

    session[:uniq_key] ||= key

    redirect_to second_tour_votes_path
  end

  def second_tour
    @fights = Candidate.get_versus
  end

  def vote_second_tour
    votes_params = params.except(:action, :controller, :utf8, :authenticity_token, :commit)
    begin
      votes_params.keys.select{|k| k.start_with?('f_')}.each do |key|
        VoteSecondTour.create_with(key, votes_params[key], session[:uniq_key])
      end
    rescue Exception => e
      HoptoadNotifier.notify e
    end
    current_user.update_attribute :a_vote_second_tour, true

    redirect_to feedbacks_path
  end

end
