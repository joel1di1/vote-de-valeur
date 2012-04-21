class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def set_locale
    I18n.locale = I18n.default_locale
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
