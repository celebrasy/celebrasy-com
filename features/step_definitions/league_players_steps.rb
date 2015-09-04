When(/^I go to that league's players page$/) do
  visit "/leagues/#{@league.id}/players"
end

Then(/^I should only see the "(.*?)" player$/) do |search_term|
  expect(page.all("table.dataTable tbody tr").count).to eq(1)
  within("table.dataTable tbody") do
    expect(page).to have_content(search_term)
  end
end
