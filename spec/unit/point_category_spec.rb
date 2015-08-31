require "rails_helper"

RSpec.describe PointCategory, { type: :model } do
  it "requires a suggested value" do
    point_category = PointCategory.create
    expect(point_category.errors).to include(:suggested_value)
  end
end
