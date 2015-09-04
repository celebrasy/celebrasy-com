When(/^I go to that league's players page$/) do
  visit "/leagues/#{@league.id}/players"
end

Then(/^I should only see the "(.*?)" player$/) do |search_term|
  expect(page.all("table.dataTable tbody tr").count).to eq(1)
  within("table.dataTable tbody") do
    expect(page).to have_content(search_term)
  end
end

Then(/^I should see the best player first$/) do
  first_row = first("table.dataTable tbody tr")
  within(first_row) do
    if @cat1.value > @cat2.value + @cat3.value
      expect(page).to have_content(@player1.name)
    else
      expect(page).to have_content(@player2.name)
    end
  end
end
