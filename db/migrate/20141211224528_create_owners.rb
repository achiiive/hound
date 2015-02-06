class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.timestamps null: false
      t.integer :github_id, null: false
      t.string :github_login, null: false
      t.boolean :organization, default: false, null: false

      t.index :github_id, unique: true
      t.index :github_login, unique: true
    end
  end
end
