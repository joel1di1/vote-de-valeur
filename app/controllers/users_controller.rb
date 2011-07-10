class UsersController < ApplicationController

  def access
    token = params[:id]
    user = User.find_by_access_token token
    if user
      sign_in user
    else
      sign_out :user
    end
    redirect_to root_path
  end

end
