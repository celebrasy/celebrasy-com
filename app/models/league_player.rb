class LeaguePlayer < ActiveRecord::Base
  belongs_to :league
  belongs_to :league_position
  belongs_to :player
  has_many :point_submissions

  def name
    "#{first_name} #{last_name}".strip
  end

  def allowed_league_positions
    return @allowed_league_positions if @allowed_league_positions

    league.flex_positions | [league_position]
  end

  def points_for_group(group)
    points_by_group[group] || 0
  end

  def total_points
    self.point_submissions.inject(0) { |n, point| n += point.points; n }
  end

  private
    def points_by_group
      @points_by_group ||= self.point_submissions.inject({}) do |h, point|
        h[point.league_point_category.group] ||= 0
        h[point.league_point_category.group] += point.points
        h
      end
    end
end
