class GameSerializer < ActiveModel::Serializer
  attributes :moves, :result, :created_at

  def moves
    [
      {
        "name": object.player_name,
        "move": object.player_move
      },
      {
        "name": "Bot",
        "move": object.computer_move
      }
    ]
  end
end