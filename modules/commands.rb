module Bot
  module DiscordCommands
    # Responds with "Pong!".
    # This used to check if bot is alive
    module Rawr
      extend Discordrb::Commands::CommandContainer
      command :rawr do |event|
        puts "worked"
        event << 'Pong!'
      end
    end
  end
end
