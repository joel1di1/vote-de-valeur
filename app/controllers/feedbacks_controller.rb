class FeedbacksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_cache_buster  
  
  def new 
    @feedback = Feedback.new
  end

  def create
    json = params.except(:controller, :action, :commit, :utf8, :authenticity_token).to_json

    Feedback.create :answers => json, :key => session[:uniq_key]

    redirect_to thanks_path
  end

end
