namespace :mails do
  task :send_opening => :environment  do |t, args|
    start_id = ENV['start']
    end_id = ENV['end']
    User.send_opening_mails(start_id, end_id)
  end  

  task :send_relance_1 => :environment  do |t, args|
    start_id = ENV['start']
    end_id = ENV['end']
    User.send_relance_1(start_id, end_id)
  end
end

