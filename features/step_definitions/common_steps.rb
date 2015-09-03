Given(/^Pending (.*)/) do |reason| pending(reason); end

Given(/^the BadCeleb League seeds have been run$/) do
  # it runs for all env seeds
  @league = League.find_by({ title: "BadCelebs" })
  @league_template = @league.league_template
end

When(/^I click on "(.*?)"$/) do |text|
  page.click_link(text)
end
