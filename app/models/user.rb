# coding: utf-8

class NoJunkMailValidator < ActiveModel::Validator
  @@banned_mails = ['test.test', 'jetable.org']

  def validate user
    if user.email
      @@banned_mails.each do |banned|
        if user.email.end_with? banned
          user.errors[:email] << "Ce mail n'est pas valide."
          return
        end
      end
    end
  end
end


class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :postal_code, :public

  validates_with NoJunkMailValidator

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
        raise "le user #{self.id} possède plusieurs votes pour le candidat #{id}"
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
    user = User.new :email => "fake_#{rand(36**8).to_s(36)}@test.test", :password => "secret"
    user.skip_confirmation!

    sleep(ENV['sleep'].to_i) unless !ENV['sleep']
    if user.save
      puts 'user saved'
    else
      puts 'error : user not saved'
    end

    if Rails.env.production? && (ENV['workers']=='auto')
      Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PWD']).set_workers("evening-moon-670", Delayed::Backend::ActiveRecord::Job.count-1)
    end
  end

end
