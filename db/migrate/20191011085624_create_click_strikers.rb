class CreateClickStrikers < ActiveRecord::Migration[6.0]
  def change
    create_table :click_strikers do |t|
      t.string :slug
      t.integer :counter, null: false
      t.string :body
    end

    add_index :click_strikers, :slug, unique: true
  end
end
