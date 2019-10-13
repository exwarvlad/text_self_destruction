class AddJidToClickStrikers < ActiveRecord::Migration[6.0]
  def change
    add_column :click_strikers, :jid, :string, default: nil
    add_index :click_strikers, :jid, unique: true
  end
end
