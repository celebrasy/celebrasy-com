class LeaguesController < ApplicationController
  before_action :set_league, only: []

  private
    def set_league
      @league = League.find(params[:league_id]) || League.find(params[:id])
    end

    def league_params
      params.require(:league).permit(:league_id)
    end
end
