class RosterManager
  class InvalidRoster < StandardError; end

  def initialize(team, options = {})
    @team = team
    @league = @team.league
    @options = options
  end

  def set_roster(roster_slots)
    validate_league_roster_positions(roster_slots)

    delete_all_existing_slots

    roster_slots.each do |roster_slot|
      validate_player_is_available(roster_slot)
      validate_player_position(roster_slot)
    end

    @team.roster_slots = roster_slots
  end

  private

  def delete_all_existing_slots
    @team.roster_slots.destroy_all
  end

  def validate_league_roster_positions(roster_slots)
    return if @options[:skip_validations]

    count_by_position(roster_slots).each do |position, requested_count|
      allowed_count = @league.positions.find(position.id).count
      if requested_count > allowed_count
        raise(InvalidRoster, "There are too many #{position.title.pluralize}")
      end
    end
  end

  def validate_player_is_available(roster_slot)
    return if @options[:skip_validations]

    existing_slot = RosterSlot.find_by({ league_player_id: roster_slot.league_player_id })

    raise(InvalidRoster, "#{roster_slot.league_player.name} is already on #{existing_slot.team.title}'s roster") if existing_slot
  end

  def validate_player_position(roster_slot)
    new_position = roster_slot.league_position
    player_position = roster_slot.league_player.league_position

    return unless new_position.strict? && player_position.id != new_position.id

    message = "#{roster_slot.league_player.name} is a #{player_position.title} and cannot be played as a #{roster_slot.league_position.title}"
    raise(InvalidRoster, message)
  end

  def count_by_position(roster_slots)
    @count_by_position ||= roster_slots.map(&:league_position).each_with_object(Hash.new(0)) { |v, h| h[v] += 1 }
  end
end
