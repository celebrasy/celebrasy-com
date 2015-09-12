require "roster_manager"

Given(/^I have a team in that league$/) do
  @team = @league.teams.create!({ title: "New Team" })
end

When(/^I go to a team$/) do
  @team = @league.teams.first
  visit "/leagues/#{@league.id}/teams/#{@team.id}"
end

When(/^I go to that team$/) do
  visit "/leagues/#{@league.id}/teams/#{@team.id}"
end

When(/^I go to view that league's teams$/) do
  visit "/leagues/#{@league.id}/teams"
end

When(/^I click on a team name$/) do
  @team = @league.teams.shuffle.first
  page.click_link @team.title
end

When(/^I edit that team$/) do
  page.click_link "Edit Roster"
end

When(/^I setup a valid player change$/) do
  joan = @team.roster_slots.active.find { |rs| rs.league_player.name == "Joan Rivers" }
  dakota = @team.roster_slots.active.find { |rs| rs.league_player.name == "Mary Kate Olsen" }
  expect(page).to have_content(dakota.league_player.name)

  within ".roster-slot-#{joan.id}" do
    page.find("select").select(dakota.league_position.title)
  end

  within ".roster-slot-#{dakota.id}" do
    page.find("select").select(joan.league_position.title)
  end
end

When(/^I setup an invalid player change$/) do
  snooki = @team.roster_slots.active.find { |rs| rs.league_player.name == "Snooki" }
  within ".roster-slot-#{snooki.id}" do
    page.find("select").select("Miscellaneous")
  end
end

Then(/^I see why the change was invalid$/) do
  page.click_button("Update Team")

  expect(page).to have_content("There are too many Miscellaneous")
end

Then(/^I should see that team's players$/) do
  @team.roster_slots.active.each do |roster_slot|
    expect(page).to have_content(roster_slot.league_player.name)
    expect(page).to have_content(roster_slot.league_position.title)
  end
end

Then(/^I should see all the league's teams$/) do
  @league.teams.each do |team|
    expect(page).to have_content(team.title)
  end
end

Then(/^I should be on the team show page$/) do
  within "h2" do
    expect(page).to have_content(@team.title)
  end
  expect(current_url).to match(%r{leagues/#{@league.id}/teams/#{@team.id}})
end

Then(/^my team is updated$/) do
  before = @team.roster_slots.active.map(&:id)
  page.click_button("Update Team")

  expect(page).to have_content("Edit Roster")
  expect(current_url).to match(%r{leagues/#{@league.id}/teams/#{@team.id}$})

  after = Team.find(@team.id).roster_slots.active.map(&:id)
  expect(before).to_not eq(after)
end

Then(/^I see the invalid player change I had submitted$/) do
  selections = page.find_all("option[selected=selected]")
  miscs = selections.map(&:text).select { |t| t == "Miscellaneous" }
  expect(miscs.count).to eq(3)
end

Given(/^there is an extra "(.*?)" in the league$/) do |pos|
  position = LeaguePosition.find_by(title: pos)
  @player = @league.players.create!(name: FFaker::Name.name, league_positions: [position])
end

When(/^I add that new player$/) do
  within('.roster-slot-10') do
    page.find("#team_roster_slots_10_league_player_id").select(@player.name)
    page.find("#team_roster_slots_10_league_position_id").select(@player.league_positions.first.title)
  end
end

When(/^I drop a "(.*?)"$/) do |pos|
  position = LeaguePosition.find_by(title: pos)
  roster_slot = @team.roster_slots.active.find { |rs| rs.league_position == position }

  within(page.find('td', text: roster_slot.league_player.name).first(:xpath,".//..")) do
    page.first("select").select("Drop")
  end
end

Then(/^I should see that team's roster history$/) do
  expect(@team.roster_slots.count).to eq(11)
  within('table.roster-history') do
    within(page.find('td', text: "Dakota Fanning").first(:xpath,".//..")) do
      expect(page).to have_content("inactive")
      expect(page).to have_content("06/30/2015")
    end
  end
end
