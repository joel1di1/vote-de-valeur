namespace :mails do
  task :send_opening => :environment do
    User.send_opening_mails
  end  
end