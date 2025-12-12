class RemoveOwnerFromGroups < ActiveRecord::Migration[8.1]
  def change
    remove_reference :groups, :owner, foreign_key: { to_table: :people }
  end
end
