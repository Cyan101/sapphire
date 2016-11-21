require 'open-uri'

module Bot
  module DiscordCommands
    module DuelystCards
      extend Discordrb::Commands::CommandContainer
      extend Discordrb::EventContainer
      command(:card, usage: '.card <card name>') do |event, *cardname|
        cardinfo = open("https://duelyststats.info/scripts/carddata/get.php?cardName=#{cardname.join('%20')}")
        event.respond cardinfo.read
      end
    end
  end
end
