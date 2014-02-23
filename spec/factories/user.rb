# spec/factories/user.rb

FactoryGirl.define do
  factory :user do
    name "Douglas Adams"
    # email "douglas@example.com"                     # This line is only used if there's a single User.
    sequence(:email) { |n| "person#{n}@example.com" } # This will generate a unique email for each User.
    password "helloworld"
    password_confirmation "helloworld"
    confirmed_at Time.now
  end
end
