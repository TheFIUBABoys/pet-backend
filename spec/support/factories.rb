FactoryGirl.define do

  factory :user, class: User do
    email { Forgery(:internet).email_address }
    password { Forgery(:basic).password }
  end

end
