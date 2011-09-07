class UsersController < ApplicationController

  def access
    token = params[:id]
    user = User.find_by_access_token token
    if user
      sign_in user
      session[VotesController::TOKEN_VALIDATED_KEY] = 'true'
      redirect_to votes_explanations_path
    else
      sign_out :user
      redirect_to root_path
    end
  end

end
