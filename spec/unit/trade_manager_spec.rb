require "rails_helper"
require "trade_manager"

RSpec.describe TradeManager do
  let(:league) { League.find_by!(title: "BadCelebs") }
  let(:team1) { league.teams.first }
  let(:team2) { league.teams.last }
  let(:trade_manager) { TradeManager.new(team1, team2) }

  let(:athlete_position) { league.positions.find_by({ title: 'Athlete' }) }
  let(:musician_position) { league.positions.find_by({ title: 'Musician' }) }
  let(:team1_athlete) { team1.roster_slots.find_by({ league_position_id: athlete_position.id }).league_player }
  let(:team2_athlete) { team2.roster_slots.find_by({ league_position_id: athlete_position.id }).league_player }
  let(:team2_musician) { team2.roster_slots.find_by({ league_position_id: musician_position.id }).league_player }

  it "executes a valid 1 for 1 exchange" do
    trade_manager.trade(team1_athlete, team2_athlete)

    expect(team1.reload.league_players.find { |p| p.name == team2_athlete.name }).to be
    expect(team2.reload.league_players.find { |p| p.name == team1_athlete.name }).to be
  end

  it "is invalid if the players are in different positions" do
    expect do
      trade_manager.trade(team1_athlete, team2_musician)
    end.to raise_error(TradeManager::InvalidTrade)
  end
end
