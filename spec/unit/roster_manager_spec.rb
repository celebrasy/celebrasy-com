require "rails_helper"
require "roster_manager"

RSpec.describe RosterManager do
  let(:league) { LeagueTemplate.first.create_league!("New Bad Celebs") }
  let(:team) { league.teams.create!({ title: "Sweet Team Bro" }) }
  let(:roster_manager) { RosterManager.new(team) }

  let(:gary_busey) { league.players.find { |p| p.name == "Gary Busey" } }
  let(:snooki) { league.players.find { |p| p.name == "Snooki" } }
  let(:to) { league.players.find { |p| p.name == "TO" } }
  let(:mike_tyson) { league.players.find { |p| p.name == "Mike Tyson" } }
  let(:athlete) { league.positions.find { |p| p.title == "Athlete" } }
  let(:actor) { league.positions.find { |p| p.title == "Actor" } }
  let(:reality_star) { league.positions.find { |p| p.title == "Reality Star" } }

  describe "#set_roster" do
    it "creates active roster slots" do
      player = league.players.shuffle.first
      roster_slots = [RosterSlot.new({ league_player: player, league_position: player.league_positions.first })]
      roster_manager.set_roster(roster_slots)

      expect(team.roster_slots.active.count).to eq(1)
      expect(team.roster_slots.active.first.active_at).to be
      expect(team.roster_slots.active.first).to be_active
    end

    it "only changes the new roster slots" do
      player = league.players.shuffle.first
      roster_slots = [RosterSlot.new({ league_player: to, league_position: athlete }), RosterSlot.new({ league_player: gary_busey, league_position: actor })]
      roster_manager.set_roster(roster_slots)

      expect(team.roster_slots.count).to eq(2)

      roster_slots = [
        RosterSlot.new({ league_player: to, league_position: athlete }),
        RosterSlot.new({ league_player: gary_busey, league_position: actor }),
        RosterSlot.new({ league_player: snooki, league_position: reality_star })
      ]
      roster_manager.set_roster(roster_slots)

      expect(team.roster_slots.count).to eq(3)
    end

    describe "validates that the new team" do
      it "has players in their real positions" do
        roster_slots = [RosterSlot.new({ league_player: gary_busey, league_position: reality_star })]
        expect do
          roster_manager.set_roster(roster_slots)
        end.to raise_error("Gary Busey is a Actor and cannot be played as a Reality Star")
      end

      it "has players in valid league positions" do
        roster_slots = [
          RosterSlot.new({ league_player: to, league_position: athlete }),
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

        roster_slots = [RosterSlot.new({ league_player: gary_busey, league_position: reality_star })]
        expect do
          roster_manager.set_roster(roster_slots)
        end.to raise_error("Gary Busey is a Actor and cannot be played as a Reality Star")

        expect(team.reload.roster_slots.active.count).to eq(1)
      end

      it "has players from other people's teams" do
        other_team = league.teams.create!({ title: "A Different Team" })
        roster_slots = [RosterSlot.new({ league_player: to, league_position: athlete })]
        RosterManager.new(other_team).set_roster(roster_slots)

        roster_slots = [RosterSlot.new({ league_player: to, league_position: athlete })]
        expect do
          roster_manager.set_roster(roster_slots)
        end.to raise_error("TO is already on A Different Team's roster")
      end

      it 'does not block players on my own team' do
        player = league.players.shuffle.first
        roster_slots = [RosterSlot.new({ league_player: player, league_position: player.league_positions.first })]
        roster_manager.set_roster(roster_slots)
        roster_slots = [RosterSlot.new({ league_player: player, league_position: player.league_positions.first })]
        roster_manager.set_roster(roster_slots)

        expect(team.roster_slots.active.count).to eq(1)
        expect(team.roster_slots.active.first.active_at).to be
        expect(team.roster_slots.active.first).to be_active
      end
    end
  end
end
