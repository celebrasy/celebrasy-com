class PointCategory < ActiveRecord::Base
  belongs_to :league_template

  validates :suggested_value, presence: true

  def attrs_for_league_point_category
    {
      point_category: self,
      title: self.title,
      group: self.group,
      value: self.suggested_value
    }
  end
end
