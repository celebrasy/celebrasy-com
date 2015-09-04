class League < ActiveRecord::Base
  belongs_to :league_template
  has_many :players, { class_name: LeaguePlayer }
  has_many :league_point_categories
  has_many :positions, { class_name: LeaguePosition }
  has_many :teams
  has_many :point_submissions

  def populate_from_league_template!
    return unless league_template

    league_template.point_categories.each do |point_category|
      next if league_point_categories.find_by({ point_category_id: point_category.id })

      league_point_categories.create!({
        point_category: point_category,
        title: point_category.title,
        group: point_category.group,
        value: point_category.suggested_value
      })
    end

    league_template.positions.each do |position|
      next if positions.find_by({ position_id: position.id })

      positions.create!({
        position: position,
        title: position.title,
        count: position.suggested_count,
        strict: position.strict
      })
    end

    league_template.players.each do |player|
      next if players.find_by({ player_id: player.id })

      players.create!({
        player: player,
        league_position: positions.find_by({ title: player.position.title }),
        first_name: player.first_name,
        last_name: player.last_name
      })
    end
  end

  def flex_positions
    @flex_positions ||= positions.reject(&:strict?)
  end

  def grouped_point_categories
    @grouped_point_categories ||= self.league_point_categories.sort_by(&:title).inject({}) do |h, point_category|
      h[point_category.group] ||= []
      h[point_category.group] << [point_category.title, point_category.id]
      h
    end
  end

  def point_category_groups
    @point_category_groups ||= self.league_point_categories.map(&:group).uniq
  end
end
