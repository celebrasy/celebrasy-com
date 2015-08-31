class PointCategory < ActiveRecord::Base
  belongs_to :league_template

  validates :suggested_value, presence: true
end
