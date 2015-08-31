When(/^I go to that league's positions page$/) do
  visit "/leagues/#{@league.id}/positions"
end

When(/^I filter the table by "(.*?)"$/) do |search_term|
  page.fill_in "Search:", with: search_term
end

Then(/^I should see the BadCeleb positions$/) do
  @league_template.positions.each do |position|
    expect(page).to have_content(position.title)
    expect(page).to have_content(position.suggested_count)
  end
end

Then(/^I should only see the "(.*?)" point categories$/) do |search_term|
  expect(page.all("table.dataTable tbody tr").count).to eq(3)
  within("table.dataTable tbody") do
    expect(page).to have_content(search_term)
  end
end
