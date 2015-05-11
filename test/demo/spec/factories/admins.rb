FactoryGirl.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@factorygirl.com" }
    password "password"
    role
  end

end
