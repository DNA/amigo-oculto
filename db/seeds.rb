# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

group = Group.create! name: "Natal 2025", password: "secret123"

leonardo = Person.create! name: "Leonardo", group: group
michelle =  Person.create! name: "Michelle", group: group

aline = Person.create! name: "Aline", group: group

davi = Person.create! name: "Davi", parent: aline, group: group
rafa = Person.create! name: "Rafa", parent: aline, group: group
gabriel = Person.create! name: "Gabriel", parent: aline, group: group

dani = Person.create! name: "Dani", group: group
luciana = Person.create! name: "Luciana", group: group
luis = Person.create! name: "Luis", group: group
diana = Person.create! name: "Diana", group: group
almir = Person.create! name: "Amir", group: group

lu_vieira = Person.create! name: "Lu Vieira", group: group
amanda = Person.create! name: "Amanda", group: group
malu = Person.create! name: "Malu", group: group
tales  = Person.create! name: "Tales", group: group
werverton = Person.create! name: "Werverton", group: group

Person.create! name: "irene", group: group

leonardo.excluded_people << michelle
michelle.excluded_people << leonardo

aline.excluded_people << [ dani, davi, rafa, gabriel ]
dani.excluded_people << [ aline, davi, rafa, gabriel ]
davi.excluded_people << [ aline, dani, rafa, gabriel ]
rafa.excluded_people << [ aline, dani, davi, gabriel ]
gabriel.excluded_people << [ aline, dani, davi, rafa ]

luciana.excluded_people << luis
luis.excluded_people << luciana

diana.excluded_people << almir
almir.excluded_people << diana

amanda.excluded_people << werverton
werverton.excluded_people << amanda

diana.excluded_people << almir
almir.excluded_people << diana

lu_vieira.excluded_people << [ malu, tales ]
malu.excluded_people << [ lu_vieira, tales ]
tales.excluded_people << [ lu_vieira, malu ]
