class RosterManager
  class InvalidRoster < StandardError; end

  def initialize(team, options = {})
    @team = team
    @league = @team.league
    @options = options
  end

  def set_roster(roster_slots)
    validate_league_roster_positions(roster_slots)

    roster_slots.each do |roster_slot|
      validate_player_is_available(roster_slot)
      validate_player_position(roster_slot)
    end

    delete_necessary_slots(roster_slots)
    new_roster_slots = prune_existing_roster_slots(roster_slots)

    @team.roster_slots << new_roster_slots
  end

  private

  def delete_necessary_slots(incoming_roster_slots)
    roster_slots_to_delete = @team.roster_slots.active.select do |roster_slot|
      incoming_roster_slots.none? { |rs| roster_slot.league_player_id == rs.league_player_id && roster_slot.league_position_id == rs.league_position_id}
    end

    if @options[:active_at]
      roster_slots_to_delete.map { |rs| rs.inactivate!(@options[:active_at]) }
    else
      roster_slots_to_delete.map(&:inactivate!)
    end
  end

  def prune_existing_roster_slots(roster_slots)
    roster_slots.select do |roster_slot|
      @team.roster_slots.active.none? { |rs| roster_slot.league_player_id == rs.league_player_id && roster_slot.league_position_id == rs.league_position_id}
    end
  end

  def validate_league_roster_positions(roster_slots)
    count_by_position(roster_slots).each do |position, requested_count|
      allowed_count = @league.positions.find(position.id).count
      if requested_count > allowed_count
        raise(InvalidRoster, "There are too many #{position.title.pluralize}")
      end
    end
  end

  def validate_player_is_available(roster_slot)
    existing_slot = RosterSlot.active.find_by({ league_player_id: roster_slot.league_player_id })

    if existing_slot && existing_slot.team != @team
      raise(InvalidRoster, "#{roster_slot.league_player.name} is already on #{existing_slot.team.title}'s roster") 
    end
  end

  def validate_player_position(roster_slot)
    new_position = roster_slot.league_position
    player_positions = roster_slot.league_player.league_positions

    return unless new_position.strict? && !player_positions.map(&:id).include?(new_position.id)

    message = "#{roster_slot.league_player.name} is a #{player_positions.map(&:title).join("/")} and cannot be played as a #{roster_slot.league_position.title}"
    raise(InvalidRoster, message)
  end

  def count_by_position(roster_slots)
    @count_by_position ||= roster_slots.map(&:league_position).each_with_object(Hash.new(0)) { |v, h| h[v] += 1 }
  end
end
