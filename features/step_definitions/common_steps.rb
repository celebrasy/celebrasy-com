Given(/^Pending (.*)/) do |reason| pending(reason); end

Given(/^the BadCeleb League seeds have been run$/) do
  # it runs for all env seeds
  @league = League.find_by({ title: "BadCelebs" })
end

Given(/^there is a BadCeleb League$/) do
  @league_template = LeagueTemplate.find_by!({ title: "Bad Celebrity" })
  @league = League.create!({ league_template: @league_template })
end

When(/^I click on "(.*?)"$/) do |text|
  page.click_link(text)
end
