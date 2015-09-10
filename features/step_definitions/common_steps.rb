Given(/^Pending (.*)/) do |reason| pending(reason); end

Given(/^the BadCeleb League seeds have been run$/) do
  # it runs for all env seeds
  @league = League.find_by({ title: "BadCelebs" })
  @league_template = @league.league_template
end

When(/^I click on "(.*?)"$/) do |text|
  page.click_link(text)
end

When(/^I go to that league's teams$/) do
  visit "/leagues/#{@league.id}/teams"
end

When(/^I filter the table by "(.*?)"$/) do |search_term|
  page.fill_in "Search:", with: search_term
end
