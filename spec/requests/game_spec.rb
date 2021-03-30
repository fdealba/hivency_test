require 'rails_helper'

describe 'Games API', type: :request do
  describe 'GET /games/history' do
    before do
      FactoryBot.create(:game, player_name: "Phil", player_move: "scissors", computer_move: "rock", result: :computer_wins)
      FactoryBot.create(:game, player_name: "Zac", player_move: "rock", computer_move: "rock", result: :tie)
      FactoryBot.create(:game, player_name: "Peter", player_move: "rock", computer_move: "scissors", result: :player_wins)
    end

    it 'returns success status on games/history endpoint with all games' do
      get '/api/v1/games/history'
  
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["games"].size).to eq(3)
    end

    it 'returns default pagination data' do
      get '/api/v1/games/history'

      pagination_data = JSON.parse(response.body)["pagination_data"]
      expect(pagination_data.size).to eq(4)
      expect(pagination_data["current_page"]).to eq(1)
      expect(pagination_data["games_per_page"]).to eq(10)
      expect(pagination_data["total_pages"]).to eq(1)
      expect(pagination_data["total_games"]).to eq(3)
    end

    it 'should accept pagination options parameters (page, per_page)' do
      get '/api/v1/games/history?page=2&per_page=1'

      parsed_response = JSON.parse(response.body)
      pagination_data = parsed_response["pagination_data"]

      expect(parsed_response["games"].size).to eq(1)
      expect(pagination_data["current_page"]).to eq(2)
      expect(pagination_data["games_per_page"]).to eq("1")
      expect(pagination_data["total_pages"]).to eq(3)
      expect(pagination_data["total_games"]).to eq(3)
    end
  end

  describe 'POST /games/new' do
    player_name = "felipe"

    it 'creates a games/new game successfully' do
      expect {
        post '/api/v1/games/new', params: { name: player_name, move: "scissors" }
      }.to change { Game.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
    end

    it 'correctly computes the game result' do
      10.times do
        post '/api/v1/games/new', params: { name: player_name, move: "scissors" }

        parsed_response = JSON.parse(response.body)
        computer_move = parsed_response["moves"][1]["move"]
        result = parsed_response["result"]

        case computer_move
        when "scissors"
          expect(result).to eq("Tie!")
        when "rock"
          expect(result).to eq("Bot Wins!")
        when "paper"
          expect(result).to eq("#{player_name} Wins!")
        end
      end

      10.times do
        post '/api/v1/games/new', params: { name: player_name, move: "paper" }

        parsed_response = JSON.parse(response.body)
        computer_move = parsed_response["moves"][1]["move"]
        result = parsed_response["result"]

        case computer_move
        when "paper"
          expect(result).to eq("Tie!")
        when "scissors"
          expect(result).to eq("Bot Wins!")
        when "rock"
          expect(result).to eq("#{player_name} Wins!")
        end
      end

      10.times do
        post '/api/v1/games/new', params: { name: player_name, move: "rock" }

        parsed_response = JSON.parse(response.body)
        computer_move = parsed_response["moves"][1]["move"]
        result = parsed_response["result"]

        case computer_move
        when "rock"
          expect(result).to eq("Tie!")
        when "paper"
          expect(result).to eq("Bot Wins!")
        when "scissors"
          expect(result).to eq("#{player_name} Wins!")
        end
      end
    end

    it 'returns a validation error if request move input is incorrect' do
      expect {
        post '/api/v1/games/new', params: { name: player_name, move: "asd" }
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Player move is not included in the list")
    end

    it 'returns a validation error if request is missing a name' do
      expect {
        post '/api/v1/games/new', params: { name: "", move: "rock" }
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Player name can't be blank")
    end
  end
end