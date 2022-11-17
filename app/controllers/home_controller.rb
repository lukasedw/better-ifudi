require "populate_restaurants"

class HomeController < ApplicationController
  def index
    restaurants = Restaurant.where(quantity: nil)

    restaurants.each do |restaurant|
      client = Faraday.new("https://wsloja.ifood.com.br/") do |f|
        f.request :json # encode req bodies as JSON and automatically set the Content-Type header
        f.response :json # decode response bodies as JSON
        f.request :retry, {
          retry_statuses: [429, 500],
          max: 20,
          interval: 0.5,
          interval_randomness: 0.5,
          backoff_factor: 2
        }
      end

      response = client.get("ifood-ws-v3/restaurant/evaluations", filterJson: "#{{"restaurantUuid": restaurant["id"],"page":1,"pageSize":30,"visible":true}.to_json}")

      if response.body["data"].nil?
        puts "deu merda"
        puts "#{response.status}"
        next
      end

      restaurant.update(quantity: response.body["data"]["quantity"])
    end

    @everyone = restaurants
  end

end
