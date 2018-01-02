class ChangeUsernameInPeople < ActiveRecord::Migration[5.1]
  def change
    add_index :people, :username, unique: true
  end
end
