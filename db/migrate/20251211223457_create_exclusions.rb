class CreateExclusions < ActiveRecord::Migration[8.1]
  def change
    create_table :exclusions do |t|
      t.references :group, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.references :excluded_person, null: false, foreign_key: { to_table: :people }

      t.timestamps
    end
  end
end
