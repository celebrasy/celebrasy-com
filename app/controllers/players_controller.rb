class PlayersController < ApplicationController
  before_action :set_league

  def index
    @players = @league.players
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
end
