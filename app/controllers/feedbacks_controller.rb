class FeedbacksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_cache_buster  

  before_filter :has_no_feedbacks

  def new 
    @feedback = Feedback.new
  end

  def create
    json = params.except(:controller, :action, :commit, :utf8, :authenticity_token).to_json

    Feedback.create :answers => json, :key => session[:uniq_key]
    current_user.update_attribute :feedbacks, true

    redirect_to thanks_path
  end

  protected
    def has_no_feedbacks
      redirect_to thanks_path if current_user.feedbacks
    end

end
