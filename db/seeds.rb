# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

leonardo = Person.create! name: "Leonardo"
michelle =  Person.create! name: "Michelle"

aline = Person.create! name: "Aline"

davi = Person.create! name: "Davi", parent: aline
rafa = Person.create! name: "Rafa", parent: aline
gabriel = Person.create! name: "Gabriel", parent: aline

dani = Person.create! name: "Dani"
luciana = Person.create! name: "Luciana"
luis = Person.create! name: "Luis"
diana = Person.create! name: "Diana"
amir = Person.create! name: "Amir"
irene = Person.create! name: "irene"

group = Group.new name: "Natal 2025", owner: leonardo
