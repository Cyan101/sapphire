module Bot
  module DiscordCommands
    module Rawr
      extend Discordrb::Commands::CommandContainer
      extend Discordrb::EventContainer
      bot.command(:card, help_available: false) do |event, *cardname|
        cardinfo = open("https://duelyststats.info/scripts/carddata/get.php?cardName=#{cardname.join('%20')}")
        event.respond cardinfo.read
      end
    end
  end
end
