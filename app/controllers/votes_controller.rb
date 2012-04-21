#coding: UTF-8
class VotesController < ApplicationController
  before_filter :authenticate_user!
  TOKEN_VALIDATED_KEY = 'token_validated'

  def index
    redirect_to root_path and return unless user_signed_in?
    unless DateHelper.election_started?
      flash[:error] = "Le bureau de vote n'est pas ouvert"
      redirect_to root_path and return
    end

    if session.include?(TOKEN_VALIDATED_KEY) && session[TOKEN_VALIDATED_KEY]
      @candidates = Candidate.all.shuffle
      @user = current_user
      if current_user.a_vote?
        flash[:error] = "Vous avez déjà validé l'étape précédente."
        redirect_to second_tour_votes_path
      end
    else
      flash[:error] = "Veuillez suivre le lien qui vous a été envoyé par mail pour valider votre inscription."
      redirect_to root_path
    end
  end

  def create
    unless user_signed_in?
      flash[:error] = "Veuillez suivre le lien qui vous a été envoyé par mail pour valider votre inscription."
      redirect_to root_path and return
    end

    unless DateHelper.election_started?
      flash[:error] = "Le bureau de vote n'est pas ouvert"
      redirect_to root_path and return
    end

    unless current_user.a_vote?
      key = current_user.vote! params[:user]
      session[:uniq_key] ||= key
    end

    redirect_to second_tour_votes_path
  end

  def second_tour
    flash[:error] = 'Vous avez déjà validé votre vote' and redirect_to feedbacks_path and return if current_user.a_vote_second_tour?
    @fights = Candidate.get_versus
  end

  def vote_second_tour
    flash[:error] = 'Vous avez déjà validé votre vote' and redirect_to feedbacks_path and return if current_user.a_vote_second_tour?
    session[:uniq_key] ||= User.generate_vote_key
    begin
      fights = Candidate.get_versus
      fights.each do |f|
        key = find_key_in_params f.id
        VoteSecondTour.create_with(key, params[key], session[:uniq_key])
      end
    rescue Exception => e
      HoptoadNotifier.notify e
    end
    current_user.update_attribute :a_vote_second_tour, true

    redirect_to feedbacks_path
  end

  def find_key_in_params id
    return id if params[id]
    m = /f_(\d+)_(\d+)/.match id
    "f_#{m[2]}_#{m[1]}"
  end

end
