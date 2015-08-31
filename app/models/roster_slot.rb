class RosterSlot < ActiveRecord::Base
  belongs_to :team
  belongs_to :league_position
  belongs_to :league_player

  enum({ status: [:active, :inactive] })

  before_create :set_defaults

  def set_defaults
    self.active_at = Time.now
  end
end
