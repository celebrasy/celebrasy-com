class PointCategoriesController < ApplicationController
  before_action :set_league
  before_action :set_point_category, only: []

  def index
    @point_categories = @league.league_point_categories
  end

  private
    def set_league
      @league = League.find(params[:league_id])
    end

    def set_point_category
      @point_category = PointCategory.find(params[:id])
    end

    def point_category_params
      params.require(:point_category).permit(:league_id)
    end
end
