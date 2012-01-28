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

  validates_presence_of :email
  validates_uniqueness_of :email, :access_token
  validates_with NoJunkMailValidator

  after_create :send_confirmation_mail

  before_validation :add_access_token

  def add_access_token
    self.access_token = User.generate_access_token unless self.access_token
  end

  def method_missing method_name, *args, &block
    case method_name
      when /^vote_for_candidate_(\d*)$/ then
        nil
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

  def vote! votes_hash
    Candidate.all.each do |candidate|
      value_string = nil
      value_string = votes_hash["vote_for_candidate_#{candidate.id}"] if votes_hash

      vote_value = parse_vote_value value_string

      Vote.create :candidate => candidate, :vote => vote_value
    end

    self.update_attribute :a_vote, true
  end

  def classic_vote! classic_vote_hash
    candidate = Candidate.find(classic_vote_hash[:classic_vote]) if classic_vote_hash && classic_vote_hash[:classic_vote]
    ClassicVote.create :candidate => candidate if candidate

    self.update_attribute :a_vote_classic, true
  end

  def parse_vote_value value_string
    vote_value = value_string.to_i if (value_string && value_string.match(/^[-+]?\d+$/))
    vote_value ||= nil
  end

end
