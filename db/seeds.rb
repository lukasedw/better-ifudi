# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


require "populate_restaurants"

restaurants = PopulateRestaurants.new.everyone

restaurants.each do |restaurant|
  Restaurant.create(
    id_ifudi: restaurant["id"],
    name: restaurant["name"],
    action: restaurant["action"],
    available: restaurant["available"],
    user_rating: restaurant["userRating"]
  )
end