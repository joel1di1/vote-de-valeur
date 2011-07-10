# coding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "joel1di1+vote-de-valeur@gmail.com"

  def send_confirmation user
    @user = user
    mail(:to => user.email, :subject => "Bienvenue dans l'expérimentation du vote de valeur")
  end

  def election_open_mail user
    @user = user
    mail(:to => user.email, :subject => "Le vote de valeur est ouvert")
  end
end
