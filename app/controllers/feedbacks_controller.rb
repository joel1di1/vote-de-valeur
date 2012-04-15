class FeedbacksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_cache_buster  

  before_filter :has_no_feedbacks

  def new 
    @feedback = Feedback.new
  end

  def create
    session[:uniq_key] ||= User.generate_vote_key
    json = params.except(:controller, :action, :commit, :utf8, :authenticity_token).to_json

    Feedback.create :answers => json, :key => session[:uniq_key]
    current_user.update_attribute :feedbacks, true

    redirect_to thanks_path
    sign_out
  end

  protected
    def has_no_feedbacks
      if current_user.feedbacks
        flash[:error] = t(:questionnaire_rempli)
        redirect_to thanks_path 
      end
    end

end
