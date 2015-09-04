class PlayersController < ApplicationController
  before_action :set_league

  def index
    @players = @league.players
  end

  private
    def set_league
      @league = League.find(params[:league_id])
    end
end
