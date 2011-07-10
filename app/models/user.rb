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
  devise :database_authenticatable, :registerable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :postal_code, :public

  validates_presence_of :email, :first_name, :last_name, :postal_code
  validates_uniqueness_of :email, :access_token
  validates_with NoJunkMailValidator

  has_many :votes, :dependent => :destroy
  has_one :classic_vote, :dependent => :destroy

  after_create :send_confirmation_mail

  before_validation :add_access_token

  def add_access_token
    self.access_token = User.generate_access_token unless self.access_token
  end

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

  def send_confirmation_mail
    UserMailer.send_confirmation(self).deliver
  end

  def self.generate_access_token
    token = rand(36**64).to_s(36)
    while User.find_by_access_token(token)
      token = rand(36**64).to_s(36)
    end
    token
  end

end
