class Person < ApplicationRecord
  has_many :groups

  has_many :child, class_name: "Person"
  belongs_to :parent, class_name: "Person", required: false
end
