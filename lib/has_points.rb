module HasPoints
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
