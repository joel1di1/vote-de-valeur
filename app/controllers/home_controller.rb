class HomeController < ApplicationController

  def index
    if user_signed_in?
      render :election_soon
    else
      @user =  User.new
    end
  end

  def add_user
    if Rails.env.production? && (ENV['workers']=='auto')
      h = Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PWD'])
      h.set_workers("evening-moon-670", h.workers("evening-moon-670")+1)
    end

    User.delay.add_fake
    render :json => {'res' => 'OK'}
  end

end
