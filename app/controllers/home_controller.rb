class HomeController < ApplicationController

  def index
    if user_signed_in?
      render :election_soon
    else
      @user =  User.new
    end
  end
end
