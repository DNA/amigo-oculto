class CreateDraws < ActiveRecord::Migration[8.1]
  def change
    create_table :draws do |t|
      t.references :group, null: false, foreign_key: true
      t.references :giver, null: false, foreign_key: { to_table: :people }
      t.references :receiver, null: false, foreign_key: { to_table: :people }

      t.timestamps
    end

    add_index :draws, [ :group_id, :giver_id ], unique: true
    add_index :draws, [ :group_id, :receiver_id ], unique: true
  end
end
