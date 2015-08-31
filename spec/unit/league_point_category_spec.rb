require "rails_helper"

RSpec.describe LeaguePointCategory, { type: :model } do
  it "requires a value" do
    point_category = LeaguePointCategory.create
    expect(point_category.errors).to include(:value)
  end
end
