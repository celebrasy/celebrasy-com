When(/^I submit points for a player$/) do
  page.visit("/leagues/#{@league.id}/point_submissions/new?team_id=#{@league.teams.first.id}")
  select2 "Burning Alive", from: "Point Category"
  page.fill_in('point_submission_proof_url', with: "http://www.gossipcop.com/snooki-slams-in-touch-jionni-lavalle-rumors-twitter/")
  page.click_button('Submit')
end

Then(/^I should see the points for that player$/) do
  within(".point-submissions table") do
    expect(page).to have_content("Burning Alive")
    expect(page).to have_content("Health")
    expect(page).to have_content("submitted")
    expect(page).to have_content("175.0")
  end
end

Given(/^one team has a bunch of points$/) do
  @team = @league.teams.shuffle.first

  cats = @league.league_point_categories.shuffle
  players = @team.league_players.shuffle

  @cat1 = cats.pop
  @player1 = players.pop
  @league.point_submissions.create!(league_player: @player1, league_point_category: @cat1)

  @cat2 = cats.pop
  @player2 = players.pop
  @league.point_submissions.create!(league_player: @player2, league_point_category: @cat2)

  @cat3 = cats.pop
  @league.point_submissions.create!(league_player: @player2, league_point_category: @cat3)
end

Then(/^I should see each player's points broken down by group$/) do
  within(page.find('td', text: @player1.name).first(:xpath,".//..")) do
    expect(page).to have_content(@cat1.value)
  end

  within(page.find('td', text: @player2.name).first(:xpath,".//..")) do
    expect(page).to have_content(@cat2.value)
  end

  within(page.find('td', text: @player2.name).first(:xpath,".//..")) do
    expect(page).to have_content(@cat3.value)
  end
end

Then(/^I should see each player's total points$/) do
  within(page.find('td', text: @player1.name).first(:xpath,".//..")) do
    expect(page).to have_content(@cat1.value)
  end

  within(page.find('td', text: @player2.name).first(:xpath,".//..")) do
    expect(page).to have_content(@cat2.value + @cat3.value)
  end
end
