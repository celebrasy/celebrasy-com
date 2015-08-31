class PointCategoriesController < ApplicationController
  before_action :set_league
  before_action :set_point_category, only: [:show, :edit, :update, :destroy]

  # GET /point_categories
  # GET /point_categories.json
  def index
    @point_categories = @league.league_point_categories
  end

  # GET /point_categories/1
  # GET /point_categories/1.json
  def show
  end

  # GET /point_categories/new
  def new
    @point_category = PointCategory.new
  end

  # GET /point_categories/1/edit
  def edit
  end

  # POST /point_categories
  # POST /point_categories.json
  def create
    @point_category = PointCategory.new(point_category_params)

    respond_to do |format|
      if @point_category.save
        format.html { redirect_to @point_category, notice: 'Point category was successfully created.' }
        format.json { render :show, status: :created, location: @point_category }
      else
        format.html { render :new }
        format.json { render json: @point_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /point_categories/1
  # PATCH/PUT /point_categories/1.json
  def update
    respond_to do |format|
      if @point_category.update(point_category_params)
        format.html { redirect_to @point_category, notice: 'Point category was successfully updated.' }
        format.json { render :show, status: :ok, location: @point_category }
      else
        format.html { render :edit }
        format.json { render json: @point_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /point_categories/1
  # DELETE /point_categories/1.json
  def destroy
    @point_category.destroy
    respond_to do |format|
      format.html { redirect_to point_categories_url, notice: 'Point category was successfully destroyed.' }
      format.json { head :no_content }
    end
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
