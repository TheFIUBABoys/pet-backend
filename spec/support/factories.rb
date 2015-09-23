FactoryGirl.define do

  factory :user, class: User do
    trait :facebook do
      facebook_id { Forgery(:basic).text(at_least: 8) }
      facebook_token { Forgery(:basic).text(at_least: 8) }
    end

    trait :email do
      email { Forgery(:internet).email_address }
      password { Forgery(:basic).text(at_least: 8) }
    end
  end

  factory :pet, class: Pet do
    association :user, :email
    name { Forgery(:name).first_name }

    trait :dog do
      type Dog.name
    end

    trait :cat do
      type Cat.name
    end

    trait :male do
      gender Pet::GENDER_MALE
    end

    trait :female do
      gender Pet::GENDER_FEMALE
    end

    trait :published do
      published true
    end

    trait :unpublished do
      published false
    end
  end

end
