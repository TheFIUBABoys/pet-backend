FactoryGirl.define do

  factory :user, class: User do
    trait :facebook_auth do
      facebook_id { Forgery(:basic).text(at_least: 8) }
      facebook_token { Forgery(:basic).text(at_least: 8) }
    end

    trait :email_auth do
      email { Forgery(:internet).email_address }
      password { Forgery(:basic).text(at_least: 8) }
    end
  end

  factory :pet, class: Pet do
    association :user, :email_auth
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

  factory :pet_image, class: PetImage do
    association :pet, :dog, :male, :published
    image { File.new(Rails.root + "spec/fixtures/images" + "image.png") }
  end

end
