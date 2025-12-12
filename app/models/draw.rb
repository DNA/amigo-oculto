class Draw < ApplicationRecord
  belongs_to :group
  belongs_to :giver, class_name: "Person"
  belongs_to :receiver, class_name: "Person"

  validates :giver_id, uniqueness: { scope: :group_id }
  validates :receiver_id, uniqueness: { scope: :group_id }
end
