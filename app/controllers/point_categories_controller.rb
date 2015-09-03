class PointCategoriesController < ApplicationController
  before_action :set_league

  def index
    @point_categories = @league.league_point_categories
  end

  private
    def set_league
      @league = League.find(params[:league_id])
    end
end
