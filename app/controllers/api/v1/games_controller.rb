class Api::V1::GamesController < ApplicationController
  before_action :set_page, :set_per_page, only: :index

  def new
    @game = Game.new(
      player_name: move_params[:name],
      player_move: move_params[:move],
      computer_move: random_move
    )
    if @game.save!
      render :new, status: :created
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  def index
    @games = Game.page(@page).per(@per_page)
  end

  private

  def move_params
    params.permit(:name, :move)
  end

  def random_move
    Game::VALID_MOVES.sample
  end

  def set_page
    @page ||= params[:page] || 1
  end

  def set_per_page
    @per_page ||= params[:per_page] || 10
  end
end