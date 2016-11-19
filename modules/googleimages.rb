module Bot
  module DiscordCommands
    module GoogleImages
      extend Discordrb::Commands::CommandContainer
      
      API_KEY = File.readlines('googleapi.txt')[0].chomp
      CX_KEY = File.readlines('googleapi.txt')[1].chomp
      BASE_URL = "https://www.googleapis.com/customsearch/v1?key=#{API_KEY}&cx=#{CX_KEY}&fields=items(link)&searchType=image&num=1"
      
      gimages_desc = 'Searches google images'
      gimages_usage = '.gimages <what to search>'
      
      command( :gimages, description: gimages_desc, help_available: true, usage: gimages_usage) do |event, *search|
        query = URI.encode(search.join(' '))
        apijson = open(BASE_URL + "&q=#{query}&safe=medium")
        response = JSON.parse(apijson.read)
        event.respond 'Nothing found :scream:' if response.empty?
        event.respond "#{response['items'][0]['link']}"
      end
    end
  end
end