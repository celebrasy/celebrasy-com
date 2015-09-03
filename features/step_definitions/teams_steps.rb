require "roster_manager"

Given(/^I have a team in that league$/) do
  @team = @league.teams.create!({ title: "New Team" })
end

When(/^I go to a team$/) do
  @team = @league.teams.first
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
  joan = @team.roster_slots.find { |rs| rs.league_player.name == "Joan Rivers" }
  dakota = @team.roster_slots.find { |rs| rs.league_player.name == "Dakota Fanning" }
  expect(page).to have_content(dakota.league_player.name)

  select dakota.league_position.title, from: dakota.league_player.name
  select joan.league_position.title, from: joan.league_player.name
end

When(/^I setup an invalid player change$/) do
  page.find('select[name="team[roster_slots][0][league_position_id]"]').select("Miscellaneous")
end

Then(/^I see why the change was invalid$/) do
  page.click_button("Update Team")

  expect(page).to have_content("There are too many Miscellaneous")
end

Then(/^I should see that team's players$/) do
  @team.roster_slots.each do |roster_slot|
    expect(page).to have_content(roster_slot.league_player.first_name)
    expect(page).to have_content(roster_slot.league_player.last_name)
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
  before = @team.roster_slots.map(&:id)
  page.click_button("Update Team")

  expect(page).to have_content("Edit Roster")
  expect(current_url).to match(%r{leagues/#{@league.id}/teams/#{@team.id}$})

  after = Team.find(@team.id).roster_slots.map(&:id)
  expect(before).to_not eq(after)
end

Then(/^I see the invalid player change I had submitted$/) do
  selections = page.find_all("option[selected=selected]")
  miscs = selections.map(&:text).select { |t| t == "Miscellaneous" }
  expect(miscs.count).to eq(3)
end
