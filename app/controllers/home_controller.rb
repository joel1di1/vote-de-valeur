class HomeController < ApplicationController

  before_filter :redirect_when_closed, :only => :index

  def index
    if user_signed_in? 
      if session[VotesController::TOKEN_VALIDATED_KEY]
        if current_user.a_vote?
          redirect_to second_tour_votes_path
        else
          redirect_to explanations_votes_path  
        end
      else
        if DateHelper.election_closed?
          flash.now[:notice] = t(:email_registered, :mail => current_user.email)
          render_closed
        else
          render :election_soon
        end
        sign_out
        @user_signed_out = true
      end
    else
      @user =  User.new
    end
  end

  def elections_closed
    @user =  User.new
  end

  def resend_instructions
  end

  def do_resend_instructions
    user = User.find_by_email params[:email]

    user.send_confirmation_mail unless user.nil?

    redirect_to root_path, :notice => t(:mail_send)
  end

  def thanks
    render
  end

  def redirect_when_closed
    if DateHelper.election_closed? && !user_signed_in?
      render_closed
    end
  end

  def render_closed
    @user =  User.new
    render 'devise/registrations/new'
    sign_out
  end

end
