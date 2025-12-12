class AddPasswordDigestToGroups < ActiveRecord::Migration[8.1]
  def change
    add_column :groups, :password_digest, :string
  end
end
