# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

password = Forgery(:basic).text(at_least: 8)
user_1 = User.create(email: Forgery(:internet).email_address, password: password, password_confirmation: password)
user_2 = User.create(email: Forgery(:internet).email_address, password: password, password_confirmation: password)

20.times do
  type   = Pet::TYPES.sample
  gender = Pet::GENDERS.sample

  pet = Pet.create(
    user: user_1,
    type: type,
    gender: gender,
    name: Forgery(:name).first_name,
    published: true,
    description: Forgery(:lorem_ipsum).text,
    colors: Forgery(:basic).color.downcase,
    location: "#{Forgery(:geo).latitude},#{Forgery(:geo).longitude}",
    vaccinated: Forgery(:basic).boolean,
    needs_transit_home: Forgery(:basic).boolean)

  question = PetQuestion.create(pet: pet, user: user_2, body: Forgery(:lorem_ipsum).text)
  answer   = PetQuestionAnswer.create(pet_question: question, body: Forgery(:lorem_ipsum).text)
end
