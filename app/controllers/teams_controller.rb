require 'roster_manager'

class TeamsController < ApplicationController
  before_action :set_league
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @teams = @league.teams
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    @roster_slots = @team.roster_slots
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      @roster_slots = populated_roster_slots
      if roster_manager.set_roster(@roster_slots)
        format.html { redirect_to [@league, @team], notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  rescue RosterManager::InvalidRoster => ex
    @team.errors.add(:base, ex.to_s)

    respond_to do |format|
      format.html { render :edit }
      format.json { render json: @team.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def roster_manager
      @manager = RosterManager.new(@team)
    end

    def populated_roster_slots
      @populated_roster_slots = team_params[:roster_slots].map { |_, rs_params| RosterSlot.new(rs_params) }
    end

    def set_league
      @league = League.find(params[:league_id])
    end

    def set_team
      @team = Team.includes(:roster_slots => {
        :league_position => [],
        :league_player => { :league => :positions }
      }).find(params[:id])
    end

    def team_params
      params.require(:team).permit(:league_id, roster_slots: [:league_player_id, :league_position_id])
    end
end
