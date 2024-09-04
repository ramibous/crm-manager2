require 'rails_helper'

RSpec.describe Campaign, type: :model do
  let(:staff) { Staff.create!(name: 'Test Staff', email: 'test@example.com', password: 'password', role: 1) }
  let(:client) { Client.create!(first_name: 'Test', last_name: 'Client') }
  let(:campaign) { Campaign.create!(name: 'Test Campaign', start_date: Date.today, end_date: Date.today + 1, staff_id: staff.id) }

  it 'successfully creates a campaign with assignments' do
    expect {
      CampaignAssignment.create!(campaign: campaign, client: client, staff: staff, task_status: 'pending')
    }.to change(CampaignAssignment, :count).by(1)
  end
end
