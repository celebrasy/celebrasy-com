class TradeManager
  class InvalidTrade < StandardError; end

  def initialize(team1, team2, options = {})
    @team1 = team1
    @team2 = team2
    @league = @team1.league
    @options = options
  end

  def trade(player1, player2)
    roster_slot1 = @team1.roster_slots.active.find_by!({ league_player_id: player1.id })
    roster_slot2 = @team2.roster_slots.active.find_by!({ league_player_id: player2.id })

    if roster_slot1.league_position != roster_slot2.league_position
      raise InvalidTrade, "#{roster_slot1.league_player.name} (#{roster_slot1.league_position.title}) cannot be traded for #{roster_slot2.league_player.name} (#{roster_slot2.league_position.title})"
    end

    new_roster_slot1 = RosterSlot.new(league_player: player2, league_position: roster_slot1.league_position)
    new_roster_slot2 = RosterSlot.new(league_player: player1, league_position: roster_slot1.league_position)
    if @options[:active_at]
      new_roster_slot1.active_at = @options[:active_at]
      new_roster_slot2.active_at = @options[:active_at]
    end

    destroy_roster_slots(roster_slot1, roster_slot2)

    team1_roster_slots = @team1.roster_slots.active.map do |rs|
      RosterSlot.new(league_player: rs.league_player, league_position: rs.league_position)
    end
    team1_roster_slots << new_roster_slot1
    RosterManager.new(@team1).set_roster(team1_roster_slots)

    team2_roster_slots = @team2.roster_slots.active.map do |rs|
      RosterSlot.new(league_player: rs.league_player, league_position: rs.league_position)
    end
    team2_roster_slots << new_roster_slot2
    RosterManager.new(@team2).set_roster(team2_roster_slots)
  end

  private

    def destroy_roster_slots(*roster_slots)
      if @options[:active_at]
        roster_slots.map { |rs| rs.inactivate!(@options[:active_at]) }
      else
        roster_slots.map(&:inactivate!)
      end
    end
end
