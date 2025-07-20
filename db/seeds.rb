# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding admin user..."

Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.password = "pass@1234"
  admin.password_confirmation = "pass@1234"
end

puts "Admin user created: admin@example.com / pass@1234"