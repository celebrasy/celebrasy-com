require 'rails_helper'

RSpec.describe PointSubmission, type: :model do
  let(:league) { League.last }
  let(:player) { league.players.shuffle.first }
  let(:point_category) { league.league_point_categories.first }
  let(:point_submission) { PointSubmission.create!(league_point_category: point_category, league_player: player) }

  it 'defaults its point values from the league_point_category' do
    expect(point_submission.points).to eq(point_category.value)
  end

  it 'starts as submitted' do
    expect(point_submission).to be_submitted
  end

  it 'finds the current team if there is one' do
    expect(point_submission.team).to eq(player.team)
  end
end
