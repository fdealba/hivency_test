require 'rails_helper'

describe 'Games API', type: :request do
  describe 'GET /games_history' do
    before do
      FactoryBot.create(:game, player_name: 'Phil', player_move: 'scissors', computer_move: 'rock')
      FactoryBot.create(:game, player_name: 'Zac', player_move: 'rock', computer_move: 'rock')
      FactoryBot.create(:game, player_name: 'Peter', player_move: 'rock', computer_move: 'scissors')
    end

    it 'returns success status on games_history endpoint with all games' do
      get '/api/v1/games_history'
  
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["games"].size).to eq(3)
    end

    it 'returns default pagination data' do
      get '/api/v1/games_history'

      meta = JSON.parse(response.body)["meta"]
      expect(meta.size).to eq(4)
      expect(meta["current_page"]).to eq(1)
      expect(meta["items_per_page"]).to eq(10)
      expect(meta["total_pages"]).to eq(1)
      expect(meta["games_count"]).to eq(3)
    end

    it 'should accept pagination options parameters (page, per_page)' do
      get '/api/v1/games_history?page=2&per_page=1'

      parsed_response = JSON.parse(response.body)
      meta = parsed_response["meta"]

      expect(parsed_response["games"].size).to eq(1)
      expect(meta["current_page"]).to eq(2)
      expect(meta["items_per_page"]).to eq("1")
      expect(meta["total_pages"]).to eq(3)
      expect(meta["games_count"]).to eq(3)
    end
  end

  describe 'POST /play' do
    it 'creates a play game successfully' do
      expect {
        post '/api/v1/play', params: { name: 'felipe', move: 'scissors' }
      }.to change { Game.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
    end

    it 'correctly computes the game result' do
      post '/api/v1/play', params: { name: 'felipe', move: 'scissors' }

      parsed_response = JSON.parse(response.body)
      computer_move = parsed_response["moves"][1]["move"]
      result = parsed_response["result"]

      case computer_move
      when "scissors"
        expect(result).to eq('Tie')
      when "rock"
        expect(result).to eq('Bot Wins!')
      when "paper"
        expect(result).to eq('felipe Wins!')
      end
    end

    it 'returns a validation error if request move input is incorrect' do
      expect {
        post '/api/v1/play', params: { name: 'felipe', move: 'asd' }
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Player move is not included in the list")
    end

    it 'returns a validation error if request is missing a name' do
      expect {
        post '/api/v1/play', params: { name: '', move: 'rock' }
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Player name can't be blank")
    end
  end
end