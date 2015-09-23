# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

password = Forgery(:basic).text(at_least: 8)
user = User.create(email: Forgery(:internet).email_address, password: password, password_confirmation: password)

20.times do
  type   = Pet::TYPES.sample
  gender = Pet::GENDERS.sample

  Pet.create(
    user: user,
    type: type,
    gender: gender,
    name: Forgery(:name).first_name,
    published: true,
    description: Forgery(:lorem_ipsum).text,
    colors: Forgery(:basic).color.downcase,
    location: "#{Forgery(:geo).latitude},#{Forgery(:geo).longitude}",
    vaccinated: Forgery(:basic).boolean,
    needs_transit_home: Forgery(:basic).boolean)
end
