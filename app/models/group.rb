class Group < ApplicationRecord
  has_secure_password

  has_many :people, dependent: :destroy
  has_many :draws, dependent: :destroy

  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }

  def draw_possible?
    validator = DrawValidator.new(self)
    validator.valid?
  end

  def draw_validation_errors
    validator = DrawValidator.new(self)
    validator.valid?
    validator.errors
  end

  def generate_draw!
    generator = DrawGenerator.new(self)
    if generator.generate
      true
    else
      errors.add(:base, generator.errors.join(", "))
      false
    end
  end

  def draw_generated?
    draws.exists?
  end
end
