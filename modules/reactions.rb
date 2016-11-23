module Bot
  module DiscordCommands
    module React
      extend Discordrb::Commands::CommandContainer
      extend Discordrb::EventContainer
      command( :waifu, help_available: false) do |event|
        event.message.react '🇦'
        event.message.react '🇱'
        event.message.react '🇹'
        event.message.react '🇪'
        event.message.react '🇷'
      end
      command :newtada, help_available: false do |event|
        event.message.react '🎉'
      end
      command :america, help_available: false do |event|
        event.message.react '🇹'
        event.message.react '🇷'
        event.message.react '🇺'
        event.message.react '🇲'
        event.message.react '🇵'
      end
      message(contains: /.{5,}\?/i) do |event|
        random = rand(1..3)
        event.message.react '✅' if random == 1
        event.message.react '❌' if random == 2
        event.message.react '❓' if random == 3
      end
      command :alter, help_available: false do |event|
        event.message.react '🍕'
      end
    end
  end
end