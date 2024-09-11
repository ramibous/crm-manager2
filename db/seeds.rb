require 'faker'

# Clear existing data
CampaignAssignment.destroy_all
Campaign.destroy_all
WishlistItem.destroy_all
Appointment.destroy_all
Purchase.destroy_all
Client.destroy_all
Staff.destroy_all

# Create staff members (both staff and managers)
staff_members_data = [
  { name: 'Staff Member', email: 'staff@example.com', password: 'password', role: 'staff' },
  { name: 'Manager One', email: 'manager1@example.com', password: 'password1', role: 'manager' },
  { name: 'Manager Two', email: 'manager2@example.com', password: 'password2', role: 'manager' }
]

staff_members = staff_members_data.map do |data|
  puts "Creating Staff Member: #{data[:name]}"
  Staff.create!(data)
end

# Assign managers to variables for easier reference
manager_one = staff_members.find { |staff| staff.role == "manager" && staff.name == "Manager One" }
manager_two = staff_members.find { |staff| staff.role == "manager" && staff.name == "Manager Two" }

# Create 100 random clients with varying purchase totals and assign them to staff members
clients_data = 20.times.map do
  {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
    phone: Faker::PhoneNumber.phone_number,          # Add phone number
    signature: Faker::Lorem.sentence(word_count: 3), # Add signature
    staff: staff_members.sample,
    manager_id: [manager_one.id, manager_two.id].sample
  }
end

clients = clients_data.map do |data|
  puts "Creating Client: #{data[:first_name]} #{data[:last_name]}"
  Client.create!(data)
end

# Create purchases for each client across different periods
clients.each do |client|
  # Randomly decide whether to create a purchase for this client
  if [true, false].sample  # This will randomly choose between true (create purchase) and false (no purchase)
    purchase_data = {
      client: client,
      amount: Faker::Commerce.price(range: 0..5000.0),
      date: Faker::Date.between(from: 1.year.ago, to: Date.today),
      product_name: Faker::Commerce.product_name
    }
    puts "Creating Purchase for Client ID: #{client.id} - Amount: #{purchase_data[:amount]} - Date: #{purchase_data[:date]}"
    Purchase.create!(purchase_data)
  else
    puts "No purchase created for Client ID: #{client.id}"
  end
end


# Create more appointments for clients
appointments_data = [
  { client: clients[0], title: 'Consultation', scheduled_at: '2024-06-01', staff: staff_members[0] },
  { client: clients[1], title: 'Follow-up', scheduled_at: '2024-07-01', staff: staff_members[1] },
  { client: clients[2], title: 'New Product Meeting', scheduled_at: '2024-09-01', staff: staff_members[2] },
  { client: clients[3], title: 'Annual Review', scheduled_at: '2024-10-01', staff: staff_members[0] }
]

appointments_data.each { |data| Appointment.create!(data) }

# Create more wishlist items for clients
wishlist_items_data = [
  { client: clients[2], item_name: 'Wishlist Item 1', item_reference: 'REF123' },
  { client: clients[3], item_name: 'Wishlist Item 2', item_reference: 'REF456' },
  { client: clients[4], item_name: 'Wishlist Item 3', item_reference: 'REF789' },
  { client: clients[5], item_name: 'Wishlist Item 4', item_reference: 'REF101' }
]

wishlist_items_data.each { |data| WishlistItem.create!(data) }

# Create more campaigns for the store
campaigns_data = [
  { name: 'Summer Sale', start_date: '2024-08-01', end_date: '2024-08-31', staff: staff_members[0] },
  { name: 'Winter Sale', start_date: '2024-12-01', end_date: '2024-12-31', staff: staff_members[0] },
  { name: 'Spring Promotion', start_date: '2024-04-01', end_date: '2024-04-30', staff: staff_members[1] },
  { name: 'Black Friday', start_date: '2024-11-25', end_date: '2024-11-29', staff: staff_members[1] }
]

campaigns = campaigns_data.map do |data|
  puts "Creating Campaign: #{data[:name]}"
  Campaign.create!(data)
end

# Assign more clients to campaigns
campaign_assignments_data = [
  { client_id: clients[4].id, campaign_id: campaigns[0].id, staff_id: staff_members[2].id },
  { client_id: clients[3].id, campaign_id: campaigns[1].id, staff_id: staff_members[2].id },
  { client_id: clients[5].id, campaign_id: campaigns[2].id, staff_id: staff_members[0].id },
  { client_id: clients[6].id, campaign_id: campaigns[3].id, staff_id: staff_members[1].id }
]

campaign_assignments_data.each { |data| CampaignAssignment.create!(data) }

puts "Seed data created successfully!"
