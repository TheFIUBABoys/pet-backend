# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Dog.create(name: "Max", description: "Very nice dog", gender: Pet::GENDER_MALE, colors: "black brown")
Cat.create(name: "Eric", description: "Very nice cat", gender: Pet::GENDER_MALE, colors: "black white")
