require "rails_helper"
require "roster_manager"

RSpec.describe RosterManager do
  let(:league) { LeagueTemplate.first.create_league!("New Bad Celebs") }
  let(:team) { league.teams.create!({ title: "Sweet Team Bro" }) }
  let(:roster_manager) { RosterManager.new(team) }

  let(:mel_gibson) { league.players.find { |p| p.name == "Mel Gibson" } }
  let(:ocho_cinco) { league.players.find { |p| p.name == "Chad Ocho Cinco" } }
  let(:mike_tyson) { league.players.find { |p| p.name == "Mike Tyson" } }
  let(:athlete) { league.positions.find { |p| p.title == "Athlete" } }
  let(:reality_star) { league.positions.find { |p| p.title == "Reality Star" } }

  describe "#set_roster" do
    it "creates active roster slots" do
      player = league.players.shuffle.first
      roster_slots = [RosterSlot.new({ league_player: player, league_position: player.league_positions.first })]
      roster_manager.set_roster(roster_slots)

      expect(team.roster_slots.count).to eq(1)
      expect(team.roster_slots.first.active_at).to be
      expect(team.roster_slots.first).to be_active
    end

    describe "validates that the new team" do
      it "has players in their real positions" do
        roster_slots = [RosterSlot.new({ league_player: mel_gibson, league_position: reality_star })]
        expect do
          roster_manager.set_roster(roster_slots)
        end.to raise_error("Mel Gibson is a Actor and cannot be played as a Reality Star")
      end

      it "has players in valid league positions" do
        roster_slots = [
          RosterSlot.new({ league_player: ocho_cinco, league_position: athlete }),
          RosterSlot.new({ league_player: mike_tyson, league_position: athlete })
        ]
        expect do
          roster_manager.set_roster(roster_slots)
        end.to raise_error("There are too many Athletes")
      end

      it 'is valid, without deleting existing slots' do
        player = league.players.shuffle.first
        roster_slots = [RosterSlot.new({ league_player: player, league_position: player.league_positions.first })]
        roster_manager.set_roster(roster_slots)

        roster_slots = [RosterSlot.new({ league_player: mel_gibson, league_position: reality_star })]
        expect do
          roster_manager.set_roster(roster_slots)
        end.to raise_error("Mel Gibson is a Actor and cannot be played as a Reality Star")

        expect(team.reload.roster_slots.count).to eq(1)
      end

      it "has players from other people's teams" do
        other_team = league.teams.create!({ title: "A Different Team" })
        roster_slots = [RosterSlot.new({ league_player: ocho_cinco, league_position: athlete })]
        RosterManager.new(other_team).set_roster(roster_slots)

        roster_slots = [RosterSlot.new({ league_player: ocho_cinco, league_position: athlete })]
        expect do
          roster_manager.set_roster(roster_slots)
        end.to raise_error("Chad Ocho Cinco is already on A Different Team's roster")
      end

      it 'does not block players on my own team' do
        player = league.players.shuffle.first
        roster_slots = [RosterSlot.new({ league_player: player, league_position: player.league_positions.first })]
        roster_manager.set_roster(roster_slots)
        roster_slots = [RosterSlot.new({ league_player: player, league_position: player.league_positions.first })]
        roster_manager.set_roster(roster_slots)

        expect(team.roster_slots.count).to eq(1)
        expect(team.roster_slots.first.active_at).to be
        expect(team.roster_slots.first).to be_active
      end
    end
  end
end
