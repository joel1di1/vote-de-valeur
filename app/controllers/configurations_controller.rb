#coding: UTF-8
class ConfigurationsController < ApplicationController

  def start_mail
    user = User.find_by_email params[:email]
    if user
      UserMailer.election_open_mail(user).deliver
      flash[:notice] = "mail envoyé"
    else
      flash[:error] = "le mail ne correspond à aucun utilisateur enregistré"
    end
    redirect_to :action => :index
  end

end
