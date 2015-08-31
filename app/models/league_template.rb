class LeagueTemplate < ActiveRecord::Base
  has_many :leagues
  has_many :players
  has_many :point_categories
  has_many :positions

  def create_league!(title)
    league = League.create!({ title: title, league_template: self })
    league.create_positions_from_league_template!
    league.create_players_from_league_template!
    league.create_point_categories_from_league_template!
    league
  end
end
