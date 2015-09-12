require "csv"
require "roster_manager"

class Seeds
  class PresidentialDebates
    def self.seed!
      league_template = setup_league_template
      league = setup_league(league_template)
      setup_teams(league)
    end

    def self.setup_league_template
      league_template = LeagueTemplate.find_or_create_by!({ title: "2016 Presidential Debates" })

      CSV.foreach("db/seeds/presidential_debates/point_categories.csv") do |(group, title, value)|
        next unless group.present?
        next if league_template.point_categories.find_by({ title: title, group: group })

        league_template.point_categories.create!({ title: title, group: group, suggested_value: value })
      end

      CSV.foreach("db/seeds/presidential_debates/league_positions.csv") do |(title, count, strict)|
        next unless title.present?
        next if league_template.positions.find_by({ title: title })

        league_template.positions.create!({ title: title, suggested_count: count, strict: strict })
      end

      CSV.foreach("db/seeds/presidential_debates/players.csv") do |(name, pos)|
        next if league_template.players.find_by({ name: name })

        league_template.players.create!({
          name: name,
          position: Position.find_by!({ title: pos })
        })
      end

      league_template
    end

    def self.setup_league(league_template)
      league_template.leagues.find_by(title: "PresidentialDebates") || league_template.create_league!("PresidentialDebates")
    end

    def self.setup_teams(league)
      [
        ['I Like This Guy', 'Gwynne'],
        ['Jeb Bushy', 'Geoff']
      ].each do |(title, owner)|
        league.teams.find_or_create_by!({ title: title, owner: owner })
      end

      populate_teams_with_players(league)
    end

    def self.populate_teams_with_players(league)
      players = league.players.shuffle

      [['Geoff', 'Donald Trump', 'Ted Cruz'],
       ['Gwynne', 'Mike Huckabee', 'Jeb Bush']].each do |(owner, p1, p2)|
        team = Team.find_by({ owner: owner })
        player1 = LeaguePlayer.find_by({ name: p1 })
        r1 = RosterSlot.new({
          league_player: player1,
          league_position: player1.league_position
        })
        player2 = LeaguePlayer.find_by({ name: p2 })
        r2 = RosterSlot.new({
          league_player: player2,
          league_position: player2.league_position
        })
        RosterManager.new(team).set_roster([r1, r2])
      end
    end

    def self.delete_things
      Team.destroy_all
      RosterSlot.destroy_all
    end
  end
end
