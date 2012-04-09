class HomeController < ApplicationController

  def index
    if user_signed_in?
      sign_out
      @user_signed_out = true
      render :election_soon
    else
      @user =  User.new
    end
  end

  def resend_instructions
  end

  def do_resend_instructions
    user = User.find_by_email params[:email]

    user.send_confirmation_mail unless user.nil?

    redirect_to root_path, :notice => t(:mail_send)
  end

  def thanks
    sign_out
  end
end
