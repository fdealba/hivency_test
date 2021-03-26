class Api::V1::GamesController < ApplicationController
  def new
    game = Game.new(player_name: move_params[:name], player_move: move_params[:move], computer_move: random_move)
    if game.save!
      render json: game.as_json, status: :created
    else
      render json: game.errors, status: :unprocessable_entity
    end
  end

  def index
    games = Game.page(page).per(per_page)
    render json: games, meta: pagination_data(games), adapter: :json
  end

  private

  def move_params
    params.permit(:name, :move)
  end

  def page
    @page ||= params[:page] || 1
  end

  def per_page
    @per_page ||= params[:per_page] || 10
  end

  def pagination_data(collection)
    {
      current_page: collection.current_page,
      items_per_page: per_page,
      total_pages: collection.total_pages,
      games_count: collection.total_count
    }
  end

  def random_move
    Game::VALID_MOVES.sample
  end
end