class Exclusion < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :person
  belongs_to :excluded_person, class_name: "Person"

  before_validation :set_group_from_person

  private

  def set_group_from_person
    self.group ||= person&.group
  end
end
