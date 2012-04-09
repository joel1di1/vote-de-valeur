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

  # def update
  #   unless user_signed_in?
  #     redirect_to root_path and return
  #   end


  #   unless DateHelper.election_running?
  #     flash[:error] = "Le bureau de vote n'est pas ouvert"
  #     redirect_to root_path and return
  #   end

  #   if current_user.a_vote?
  #     flash[:error] = "Vous avez déjà voté"
  #     redirect_to root_path and return
  #   end

  #   current_user.vote! params[:user]

  #   redirect_to votes_classic_path
  # end

  # def update_classic
  #   unless user_signed_in?
  #     redirect_to root_path
  #     return
  #   end

  #   unless DateHelper.election_running?
  #     flash[:error] = "Le bureau de vote n'est pas ouvert"
  #     redirect_to root_path
  #     return
  #   end

  #   if current_user.a_vote_classic?
  #     flash[:error] = "Vous avez déjà voté"
  #     redirect_to root_path
  #     return
  #   end

  #   current_user.classic_vote! params[:user]

  #   redirect_to thanks_path
  # end

  def explanations

  end

end
