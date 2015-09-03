class PositionsController < ApplicationController
  before_action :set_league
  before_action :set_position, only: []

  def index
    @positions = @league.positions
  end

  private
    def set_league
      @league = League.find(params[:league_id])
    end

    def set_position
      @position = Position.find(params[:id])
    end

    def position_params
      params.require(:position).permit(:league_id)
    end
end
