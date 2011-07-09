class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    I18n.locale = I18n.default_locale
  end

   def after_inactive_sign_up_path_for(resource)
     raise 'YOPPPPP'
    puts 'coucou'
  end
end
