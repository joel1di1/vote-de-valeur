class UsersController < ApplicationController

  before_filter :is_demo, :only => [:opening_email, :send_opening_email]

  def access
    token = params[:id]
    user = User.find_by_access_token token
    if user
      sign_in user
      session[VotesController::TOKEN_VALIDATED_KEY] = 'true'
      redirect_to explanations_votes_path
    else
      sign_out :user
      redirect_to root_path
    end
  end

  def count
    respond_to do |format|
      format.js do
        var = params[:jsonp]
        var ||= "user_count"
        json = {:users => {:count => User.count}}.to_json
        render :js => "function #{var}(){return #{json};}"
      end
      format.json {render :json => {:users => {:count => User.count}}}
    end
  end


  def opening_email
    @users = User.all
  end

  def send_opening_email
    user = User.find_by_email params[:user][:email]
    UserMailer.election_open_mail(user).deliver
    render :inline => "email sent to #{user.email}"
  end

  def is_demo
    redirect_to root_path if Rails.env.production? 
  end

end
