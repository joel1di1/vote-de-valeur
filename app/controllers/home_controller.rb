class HomeController < ApplicationController

  def index

  end

  def add_user
    User.delay.add_fake
    render :json => {'res' => 'OK'}
  end

end
