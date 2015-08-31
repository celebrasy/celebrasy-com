require Rails.root.join("db/seeds/bad_celebs")
require Rails.root.join("db/seeds/bachelorette")
require Rails.root.join("db/seeds/presidential_debates")

class Seeds
  def self.delete_everything
    RosterSlot.destroy_all
    Team.destroy_all
    LeaguePlayer.destroy_all
    LeaguePointCategory.destroy_all
    LeaguePosition.destroy_all
    League.destroy_all
    Player.destroy_all
    PointCategory.destroy_all
    Position.destroy_all
    RosterSlot.destroy_all
    LeagueTemplate.destroy_all
    Team.destroy_all
  end
end
