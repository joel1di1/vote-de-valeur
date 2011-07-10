# coding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  def send_confirmation user
    @user = user
    mail(:to => user.email, :subject => "Bienvenue dans l'expérimentation du vote de valeur'")
  end
end
