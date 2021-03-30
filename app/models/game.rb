class Game < ApplicationRecord
  before_save :determine_result

  VALID_MOVES = %w[rock paper scissors]

  validates_presence_of :player_name
  validates :player_move, inclusion: { in: VALID_MOVES }
  validates :computer_move, inclusion: { in: VALID_MOVES }

  enum result: %i[tie player_wins computer_wins]

  def determine_result
    return self.result = :tie if player_move == computer_move

    results = {
      rock: computer_move == "paper" ? :computer_wins : :player_wins,
      paper: computer_move == "scissors" ? :computer_wins : :player_wins,
      scissors: computer_move == "rock" ? :computer_wins : :player_wins
    }
    self.result = results[player_move.to_sym]
  end

  def compute_result
    { computer_wins: "Bot Wins!", player_wins: "#{player_name} Wins!", tie: "Tie!" }[result.to_sym]
  end
end