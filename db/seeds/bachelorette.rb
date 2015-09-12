require "csv"
require "roster_manager"

class Seeds
  class Bachelorette
    def self.seed!
      league_template = setup_league_template
      league = setup_league(league_template)
      setup_teams(league)
    end

    def self.setup_league_template
      league_template = LeagueTemplate.find_or_create_by!({ title: "The Bachelorette" })

      CSV.foreach("db/seeds/bachelorette/point_categories.csv") do |(group, title, value)|
        next unless group.present?
        next if league_template.point_categories.find_by({ title: title, group: group })

        league_template.point_categories.create!({ title: title, group: group, suggested_value: value })
      end

      CSV.foreach("db/seeds/bachelorette/league_positions.csv") do |(title, count, strict)|
        next unless title.present?
        next if league_template.positions.find_by({ title: title })

        league_template.positions.create!({ title: title, suggested_count: count, strict: strict })
      end

      CSV.foreach("db/seeds/bachelorette/players.csv") do |(name, pos)|
        next if league_template.players.find_by({ name: name })

        league_template.players.create!({
          name: name,
          positions: [Position.find_by!({ title: pos })]
        })
      end

      league_template
    end

    def self.setup_league(league_template)
      league_template.leagues.find_by(title: "Bachelorette") || league_template.create_league!("Bachelorette")
    end

    def self.setup_teams(league)
      [
        ['Connection', 'Gwynne'],
        ['Emotion', 'Geoff']
      ].each do |(title, owner)|
        league.teams.find_or_create_by!({ title: title, owner: owner })
      end

      populate_teams_with_players(league)
    end

    def self.populate_teams_with_players(league)
      players = league.players.shuffle
      league.teams.each do |team|
        assignments = players.pop(6).map do |player|
          RosterSlot.new({
            league_player: player,
            league_position: player.league_positions.first
          })
        end.compact

        RosterManager.new(team).set_roster(assignments)
      end
    end

    def self.delete_things
      Team.destroy_all
      RosterSlot.destroy_all
    end
  end
end
