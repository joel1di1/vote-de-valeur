class HomeController < ApplicationController

  def index

  end

  def add_user
    h = Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PWD'])
    h.set_workers("evening-moon-670", h.workers("evening-moon-670")+1)
    User.delay.add_fake
    render :json => {'res' => 'OK'}
  end

end
