class PointSubmissionsController < ApplicationController
  before_action :set_league
  before_action :set_team, only: [:new, :create]
  before_action :set_point_submission, only: []

  def new
    @point_submission = @league.point_submissions.build
  end

  def create
    @point_submission = @league.point_submissions.build(point_submission_params)
    if @point_submission.save
      redirect_to [@league, @team], notice: 'Points Submitted!'
    else
      render :edit
    end
  end

  def index
  end

  private
    def set_league
      @league = League.find(params[:league_id])
    end

    def set_team
      if team_id = params[:team_id] || point_submission_params[:team_id]
        @team = Team.find(team_id)
      end
    end

    def set_point_submission
      @point_submission = PointSubmission.find(params[:id])
    end

    def point_submission_params
      params.require(:point_submission).permit(:league_id,
                                               :league_player_id,
                                               :league_point_category_id,
                                               :proof_url,
                                               :team_id
                                              )
    end
end
