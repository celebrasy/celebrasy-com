require 'roster_manager'

class TeamsController < ApplicationController
  before_action :set_league
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  def index
    @teams = @league.teams.sort_by { |t| -1 * t.total_points }
  end

  def show
  end

  def edit
  end

  def update
    @roster_slots = populated_roster_slots
    roster_manager.set_roster(@roster_slots)

    redirect_to [@league, @team], notice: 'Team was successfully updated.'
  rescue RosterManager::InvalidRoster => ex
    @team.errors.add(:base, ex.to_s)

    render :edit
  end

  private
    def roster_manager
      @manager = RosterManager.new(@team)
    end

    def populated_roster_slots
      @populated_roster_slots ||= team_params[:roster_slots].map do |_, rs_params|
        next if rs_params[:league_position_id].to_i == -1
        next if rs_params[:league_player_id].to_s == ""
        RosterSlot.new(rs_params)
      end.compact
    end

    def set_league
      @league = League.includes(:teams => [:point_submissions]).find(params[:league_id])
    end

    def set_team
      @team = Team.includes(
        :roster_slots => {
          :league_position => [],
          :league_player => {
            :league => :positions,
            :point_submissions => :league_point_category,
            :league_position => []
          }
        },
        :point_submissions => [ :league_player, :league_point_category ]
      ).find(params[:id])
      @roster_slots = @team.roster_slots
    end

    def team_params
      params.require(:team).permit(:league_id, roster_slots: [:league_player_id, :league_position_id])
    end
end
