require 'open-uri'

module Bot
  module DiscordCommands
    module DuelystCards
      extend Discordrb::Commands::CommandContainer
      extend Discordrb::EventContainer
      command([:card, :duelyst], usage: "#{CONFIG.prefix}card <card name>", min_args: 1) do |event, *cardname|
        cardinfo = open("https://duelyststats.info/scripts/carddata/get.php?cardName=#{cardname.join('%20')}")
        event.respond cardinfo.read
      end
    end
  end
end
