FactoryGirl.define do 

  sequence :email do |n|
    "email_#{n}@factory.com"
  end

  sequence :first_name do |n|
    "John_#{n}"
  end

  sequence :last_name do |n|
    "Smith_#{n}"
  end

  sequence :postal_code do |n|
    rand(99999)
  end

  sequence :public do |n|
    n%2 == 0
  end

  factory :user do |u|
    u.email {FactoryGirl.generate :email}
    u.first_name {FactoryGirl.generate :first_name}
    u.last_name {FactoryGirl.generate :last_name}
    u.postal_code {FactoryGirl.generate :postal_code}
    u.public {FactoryGirl.generate :public}
    u.access_token {User.generate_access_token}
  end

  factory :admin_user do |a|
    a.email {FactoryGirl.generate :email}
    a.password "secret"
    a.role 'admin'
    a.status true
  end

  sequence :candidate_name do |n|
    "Candidate_#{n}"
  end

  factory :candidate do |c|
    c.name {FactoryGirl.generate :candidate_name}
  end

  factory :vote do |v|
    v.candidate {FactoryGirl.create :candidate}
  end

  factory :classic_vote do |v|
    v.candidate {FactoryGirl.create :candidate}
  end
end
