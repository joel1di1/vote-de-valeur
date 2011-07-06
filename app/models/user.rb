class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me


  has_many :votes, :dependent => :destroy
  has_one :classic_vote, :dependent => :destroy

  def vote_for_candidate id
    tmp = votes.select { |v| v.candidate_id == id.to_i }
    case tmp.count
      when 1
        tmp.first.vote
      when 0
        nil
      else
        raise "le user #{self.id} possede plusieurs votes pour le candidat #{id}"
    end
  end

  def method_missing method_name, *args, &block
    case method_name
      when /^vote_for_candidate_(\d*)$/ then
        vote_for_candidate $1
      else
        super method_name, *args, &block
    end
  end


  def self.add_fake
    puts "toto"
    user = User.new :email => "fake_#{DateTime.now.to_i}@test.test", :password => "secret"
    user.skip_confirmation!

    if user.save
    else

    end

    Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PWD']).set_workers("evening-moon-670", Delayed::Backend::ActiveRecord::Job.count-1)
  end

end
