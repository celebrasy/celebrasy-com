When(/^I submit points for a player$/) do
  page.click_link('Submit Points')
  page.find("#point_submission_league_point_category_id").select("Burning Alive")
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
