Factory.sequence :email do |n|
  "email_#{n}@factory.com"
end

Factory.define :user do |u|
  u.email {Factory.next :email}
  u.password "secret"
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


