# coding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "\"Vote de Valeur, expérience 2012\" <contact@votedevaleur.org>"

  def send_confirmation user
    @user = user
    mail(:to => user.email, :subject => "Bienvenue dans l'expérimentation du Vote de Valeur")
  end

  def election_open_mail user
    @user = user
    mail(:to => user.email, :subject => "Le bureau de vote virtuel du Vote de Valeur est ouvert !")
  end

  def relance_1 user
    @user = user 
    mail(:to => user.email, :subject => "Rappel : plus que 2 jours et demi pour participer à l'expérience du Vote de Valeur ")
  end

end
