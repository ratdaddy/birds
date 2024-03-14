# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Node.find_or_create_by!(id: 130, parent_id: nil)
Node.find_or_create_by!(id: 125, parent_id: 130)
Node.find_or_create_by!(id: 2820230, parent_id: 125)
Node.find_or_create_by!(id: 4430546, parent_id: 125)
Node.find_or_create_by!(id: 5497637, parent_id: 4430546)

Bird.find_or_create_by!(id: 1, node_id: 125)
Bird.find_or_create_by!(id: 2, node_id: 130)
Bird.find_or_create_by!(id: 3, node_id: 2820230)
Bird.find_or_create_by!(id: 4, node_id: 4430546)
Bird.find_or_create_by!(id: 5, node_id: 5497637)
Bird.find_or_create_by!(id: 6, node_id: 5497637)
