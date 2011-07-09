Factory.sequence :email do |n|
  "email_#{n}@factory.com"
end

Factory.sequence :first_name do |n|
  "John_#{n}"
end

Factory.sequence :last_name do |n|
  "Smith_#{n}"
end

Factory.sequence :postal_code do |n|
  rand(99999)
end

Factory.sequence :public do |n|
  n%2 == 0
end

Factory.define :user do |u|
  u.email {Factory.next :email}
  u.password "secret"
  u.first_name {Factory.next :first_name}
  u.last_name {Factory.next :last_name}
  u.postal_code {Factory.next :postal_code}
  u.public {Factory.next :public}
  u.after_build { |u| u.skip_confirmation! }
end

Factory.define :admin_user do |a|
  a.email {Factory.next :email}
  a.password "secret"
  a.role 'admin'
  a.status true
end

Factory.sequence :candidate_name do |n|
  "Candidate_#{n}"
end

Factory.define :candidate do |c|
  c.name {Factory.next :candidate_name}
end

Factory.define :vote do |v|
  v.user {Factory :user}
  v.candidate {Factory :candidate}
end

Factory.define :classic_vote do |v|
  v.user {Factory :user}
  v.candidate {Factory :candidate}
end

