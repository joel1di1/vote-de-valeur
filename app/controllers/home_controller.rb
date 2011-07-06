class HomeController < ApplicationController

  def index

  end

  def add_user
    User.delay.add_fake
    render :json => {'res' => 'OK'}
    Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PWD']).set_workers("evening-moon-670", 1)
  end

end
