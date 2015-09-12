require "csv"
require "roster_manager"
require "trade_manager"

class Seeds
  class BadCelebs
    def self.seed!
      Seeds.delete_everything
      league_template = setup_league_template
      league = setup_league(league_template)
      setup_teams(league)
      transact_team_changes(league)
    end

    def self.setup_league_template
      league_template = LeagueTemplate.find_or_create_by!({ title: "Bad Celebrity" })

      CSV.foreach("db/seeds/bad_celebs/point_categories.csv") do |(group, title, value)|
        next if league_template.point_categories.find_by({ title: title, group: group })

        league_template.point_categories.create!({ title: title, group: group, suggested_value: value })
      end

      CSV.foreach("db/seeds/bad_celebs/league_positions.csv") do |(title, count, strict)|
        next if league_template.positions.find_by({ title: title })

        league_template.positions.create!({ title: title, suggested_count: count, strict: strict })
      end

      CSV.foreach("db/seeds/bad_celebs/players.csv") do |(name, pos)|
        next if league_template.players.find_by({ name: name })

        positions = pos.split("/")
        league_template.players.create!({
          name: name,
          positions: Position.where({ title: positions })
        })
      end

      league_template
    end

    def self.setup_league(league_template)
      league_template.leagues.find_by(title: "BadCelebs") || league_template.create_league!("BadCelebs")
    end

    def self.setup_teams(league)
      CSV.foreach("db/seeds/bad_celebs/teams.csv") do |(title, owner)|
        league.teams.find_or_create_by!({ title: title, owner: owner })
      end

      populate_teams_with_players(league)
    end

    def self.populate_teams_with_players(league)
      roster_assignments = {}
      CSV.foreach("db/seeds/bad_celebs/players.csv") do |(name, _, owner, lpos)|
        team = Team.find_by({ owner: owner })
        player = league.players.find { |p| p.name == name }
        position = league.positions.find { |p| p.title == lpos }

        roster_assignments[team] ||= []
        roster_assignments[team] << RosterSlot.new({
          league_player: player,
          league_position: position
        })
      end

      roster_assignments.each do |team, assignments|
        RosterManager.new(team).set_roster(assignments)
      end
    end

    def self.transact_team_changes(league)
      CSV.foreach("db/seeds/bad_celebs/transactions.csv") do |(date, type, owner, dropping, adding, pos)|
        if type == "Trade"
          trade(league, owner, dropping, adding, pos)
          next
        elsif type == "Swap"
          swap(league, owner, dropping, adding)
          next
        end

        existing = league.players.find_by!({ name: dropping })

        team = Team.find_by!(owner: owner)
        removing = team.roster_slots.find { |rs| rs.league_player.id == existing.id }
        player = league.players.find_by({ name: adding })
        if player.nil?
          player = league.players.create!({
            name: adding,
            league_positions: [LeaguePosition.find_by!(title: pos)]
          })
        end

        if removing.nil?
          next
        end

        roster_slots = []
        team.roster_slots.each do |rs|
          next if rs.league_player == existing
          roster_slots << RosterSlot.new(league_player_id: rs.league_player_id, league_position_id: rs.league_position_id)
        end
        roster_slots << RosterSlot.new(league_player_id: player.id, league_position_id: removing.league_position_id)

        begin
          RosterManager.new(team).set_roster(roster_slots)
        rescue RosterManager::InvalidRoster => ex
        end
      end
    end

    def self.trade(league, owner1, player1_name, owner2, player2_name)
      team1 = Team.find_by!({ owner: owner1 })
      team2 = Team.find_by!({ owner: owner2 })

      player1 = league.players.find_by!({ name: player1_name })
      player2 = league.players.find_by!({ name: player2_name })

      TradeManager.new(team1, team2).trade(player1, player2)
    end

    def self.swap(league, owner, player1_name, player2_name)
      team = Team.find_by!({ owner: owner })
      player1 = league.players.find_by!({ name: player1_name })
      player2 = league.players.find_by!({ name: player2_name })

      player1_slot = team.roster_slots.find { |rs| rs.league_player == player1 }
      player2_slot = team.roster_slots.find { |rs| rs.league_player == player2 }

      roster_slots = team.roster_slots.map do |rs|
        next if rs.league_player == player1 || rs.league_player == player2

        RosterSlot.new(league_player: rs.league_player, league_position: rs.league_position)
      end.compact

      roster_slots << RosterSlot.new(league_player: player1, league_position: player2_slot.league_position)
      roster_slots << RosterSlot.new(league_player: player2, league_position: player1_slot.league_position)

      RosterManager.new(team).set_roster(roster_slots)
    end
  end
end
