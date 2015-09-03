require 'rails_helper'

RSpec.describe PointSubmission, type: :model do
  it 'defaults its point values from the league_point_category' do
    point_category = LeaguePointCategory.last
    point_submission = PointSubmission.create!(league_point_category: point_category)
    expect(point_submission.points).to eq(point_category.value)
  end

  it 'starts as submitted' do
    point_submission = PointSubmission.create!
    expect(point_submission).to be_submitted
  end
end
