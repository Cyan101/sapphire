=begin -- This is an example
module Bot
  module DiscordCommands
    # Responds with "Pong!".
    # This used to check if bot is alive
    module Rawr
      extend Discordrb::Commands::CommandContainer
      rawr_desc = "test stuff"
      command( :rawr, description: rawr_desc, help_available: true) do |event|
        puts "worked"
        event << 'Pong!'
      end
    end
  end
end
=end