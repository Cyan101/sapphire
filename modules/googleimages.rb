# frozen_string_literal: true
require 'open-uri'

module Bot
  module DiscordCommands
    module GoogleImages
      extend Discordrb::Commands::CommandContainer

      BASE_URL = "https://www.googleapis.com/customsearch/v1?key=#{CONFIG.googleapi_key}&cx=#{CONFIG.search_key}&fields=items(link)&searchType=image&num=1"

      gimages_desc = 'Searches google images'
      gimages_usage = "#{CONFIG.prefix}gimages <what to search>"
      gimages_cooldown = 'whoaaa slow down... please wait %time%s before googling some more'
      
      bucket :gimages, limit: 2, time_span: 80, delay: 40
      command([:gimages, :search, :gis],
                bucket: :gimages, description: gimages_desc, help_available: true,
                usage: gimages_usage, rate_limit_message: gimages_cooldown, min_args: 1) do |event, *search|
        query = URI.encode(search.join(' '))
        apijson = open(BASE_URL + "&q=#{query}&safe=medium")
        response = JSON.parse(apijson.read)
        next 'Nothing found :scream:' if response.empty?
        (response['items'][0]['link'])
      end
    end
  end
end
