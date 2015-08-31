When(/^I go to that league's scoring page$/) do
  visit "/leagues/#{@league.id}/point_categories"
end

Then(/^I should see the BadCeleb point categories$/) do
  expect(page).to have_content("Appearing on a Reality Star show")
  expect(page).to have_content("Career")
  expect(page).to have_content("Next")
end
