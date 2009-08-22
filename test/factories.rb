Factory.define :user do |f|
  f.sequence(:email) {|n| "person#{n}@something.co.uk" }
  f.password 'password'
  f.first_name 'Andrew'
  f.password_confirmation { |u| u.password }
end