class PointSubmission < ActiveRecord::Base
  belongs_to :league
  belongs_to :team
  belongs_to :league_player
  belongs_to :league_point_category

  before_save :set_defaults, only: :create

  validates_presence_of :league_player, :league_point_category

  enum status: [ :submitted, :approved, :rejected ]

  private

  def set_defaults
    self.points ||= self.league_point_category.try(:value)
    self.status ||= 0
    self.team ||= league_player.team
  end
end
