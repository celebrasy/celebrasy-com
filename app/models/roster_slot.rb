class RosterSlot < ActiveRecord::Base
  belongs_to :team
  belongs_to :league_position
  belongs_to :league_player

  enum({ status: [:active, :inactive] })

  before_create :set_defaults

  def set_defaults
    self.active_at = Time.now
  end

  def league_player
    return @league_player if @league_player

    @league_player = super
    @league_player.playing_as = self.league_position if @league_player
    @league_player
  end
end
