class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :bgg_username, index: true
      t.string :slack_id, index: true
      t.string :slack_team_id
      t.string :slack_username
      t.string :email, index: true
      t.string :first_name
      t.string :last_name
      t.string :title
      t.timestamps
    end
  end
end
