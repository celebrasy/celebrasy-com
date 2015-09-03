class PositionsController < ApplicationController
  before_action :set_league

  def index
    @positions = @league.positions
  end

  private
    def set_league
      @league = League.find(params[:league_id])
    end
end
