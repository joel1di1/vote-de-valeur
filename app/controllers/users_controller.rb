class UsersController < ApplicationController

  before_filter :is_demo, :only => [:opening_email, :send_opening_email]

  def access
    token = params[:id]
    user = User.find_by_access_token token
    if user
      if user.a_vote? && user.a_vote_second_tour? &&user.feedbacks?
        flash[:error] = t(:questionnaire_rempli)
        redirect_to thanks_path
      else
        sign_in user
        session[VotesController::TOKEN_VALIDATED_KEY] = 'true'
        if user.a_vote?
          redirect_to second_tour_votes_path
        else
          redirect_to explanations_votes_path  
        end
      end
    else
      sign_out :user
      redirect_to root_path
    end
  end

  def count
    nb = User.count
    nb_votants = User.where(:a_vote => true).count
    json = {:users => {:count => nb, :votants => nb_votants}}

    respond_to do |format|
      format.js do
        var = params[:jsonp]
        var ||= "user_count"
        json.to_json
        render :js => "function #{var}(){return #{json};}"
      end
      format.json {render :json => json}
    end
  end

  def votants
    render_nb_users User.where(:a_vote => true).count
  end

  def render_nb_users(nb)
    respond_to do |format|
      format.js do
        var = params[:jsonp]
        var ||= "user_count"
        json = {:users => {:count => nb}}.to_json
        render :js => "function #{var}(){return #{json};}"
      end
      format.json {render :json => {:users => {:count => nb}}}
    end
  end

  def opening_email
    @users = User.all
  end

  def send_opening_email
    user = User.find_by_email params[:user][:email]
    UserMailer.election_open_mail(user).deliver
    flash[:notice] = "email sent to #{user.email}"
    redirect_to :back
  end

  def is_demo
    redirect_to root_path if Rails.env.production? 
  end

end
