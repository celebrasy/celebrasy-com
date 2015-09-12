require "rails_helper"

RSpec.describe RosterSlot, { type: :model } do
  it 'sets inactive_at when inactivated' do
    roster_slot = RosterSlot.create!
    roster_slot.inactivate!
    roster_slot.reload
    expect(roster_slot).to be_inactive
    expect(roster_slot.inactive_at).to be
  end
end
