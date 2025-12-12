class Person < ApplicationRecord
  has_secure_password validations: false

  belongs_to :group, optional: true

  has_many :child, class_name: "Person", foreign_key: :parent_id
  belongs_to :parent, class_name: "Person", required: false

  has_many :exclusions, dependent: :destroy
  has_many :excluded_people, through: :exclusions

  has_many :inverse_exclusions, class_name: "Exclusion", foreign_key: :excluded_person_id, dependent: :destroy
  has_many :excluded_by, through: :inverse_exclusions, source: :person

  has_many :draws_as_giver, class_name: "Draw", foreign_key: :giver_id
  has_many :draws_as_receiver, class_name: "Draw", foreign_key: :receiver_id

  def has_password?
    password_digest.present?
  end

  def my_draw
    draws_as_giver.first
  end
end
