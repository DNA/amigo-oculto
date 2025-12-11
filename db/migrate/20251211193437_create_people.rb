class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      t.references :parent, null: true, foreign_key: { to_table: :people }
      t.string :name

      t.timestamps
    end
  end
end
