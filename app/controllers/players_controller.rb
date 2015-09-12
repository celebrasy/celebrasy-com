class PlayersController < ApplicationController
  before_action :set_league

  def index
    @players = @league.players
  end

  def new
    @player = @league.players.build
  end

  def create
    @league.players.create!(player_params)

    redirect_to league_players_path(@league), notice: 'Player Added!'
  end

  private
    def set_league
      @league = League.includes({
        league_point_categories: [],
        players: {
          league_position: [],
          point_submissions: [:league_point_category]
        },
      }).find(params[:league_id])
    end

    def player_params
      params.require(:player).permit(:name, :league_position_id)
    end
end
