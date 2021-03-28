class Game < ApplicationRecord
  before_save :compute_result
  VALID_MOVES = %w[rock paper scissors]

  validates :player_name, presence: :true
  validates :player_move, inclusion: { in: VALID_MOVES }
  validates :computer_move, inclusion: { in: VALID_MOVES }

  def compute_result
    if self.player_move == self.computer_move
      self.result = "Tie"
    else
      player_wins = "#{self.player_name} Wins!"
      computer_wins = "Bot Wins!"

      result = {
        rock: self.computer_move == "scissors" ? player_wins : computer_wins,
        scissors: self.computer_move == "rock" ? computer_wins : player_wins,
        paper: self.computer_move == "scissors" ? computer_wins : player_wins
      }

      self.result = result[self.player_move.to_sym]
    end
  end

  def serializable_hash(*)
    {
      "moves": [
        {
          "name": self.player_name,
          "move": self.player_move
        },
        {
          "name": "Bot",
          "move": self.computer_move
        }
      ],
      "result": self.result
    }
  end
end