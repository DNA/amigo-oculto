class CreateGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :groups do |t|
      t.references :owner, null: true, foreign_key: { to_table: :people }
      t.string :name

      t.timestamps
    end
  end
end
