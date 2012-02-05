# coding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "\"Vote de Valeur, expérience 2012\" <contact@votedevaleur.org>"

  def send_confirmation user
    @user = user
    mail(:to => user.email, :subject => "Bienvenue dans l'expérimentation du Vote de Valeur")
  end

  def election_open_mail user
    @user = user
    mail(:to => user.email, :subject => "Le Vote de Valeur est ouvert")
  end
end
