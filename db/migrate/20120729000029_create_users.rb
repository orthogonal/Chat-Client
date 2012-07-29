class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "username"
      t.string "password"
      t.string "ip"
      t.timestamps
    end
  end
end
