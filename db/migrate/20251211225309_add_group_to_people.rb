class AddGroupToPeople < ActiveRecord::Migration[8.1]
  def change
    add_reference :people, :group, null: false, foreign_key: true
  end
end
