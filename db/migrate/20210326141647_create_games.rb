class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :player_name
      t.string :player_move
      t.string :computer_move
      t.string :result
      t.timestamps
    end
  end
end